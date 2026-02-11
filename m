Return-Path: <kvm+bounces-70859-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AxqEsCgjGmPrgAAu9opvQ
	(envelope-from <kvm+bounces-70859-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:31:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E5F125AEE
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B0581300898F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB302FF176;
	Wed, 11 Feb 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DhANDHcR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rZxNVcLY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892722FF65F
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823866; cv=none; b=Vp6zyo3dNznZBcV5NPpMaeIXv3u9vbbLruE5z5m5NhJnzX89C9s3+0ZH7WMHrbLy6eYLj+qrmkXmf+I+uuFq6kbdBLFSrnINoxVVlAeYwvp8zm40eDp9bN66g1EJjIviAFggO5bnEybeijOI5nunG855Z00hdDJmUDZFdkRBwWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823866; c=relaxed/simple;
	bh=OLUplhZRE4AQJfM2IG+CREOYzwKW/P8zAEDGcgUfHmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1brNJSxbAmvqfDGACr3be1GYBI6d1uYW7WxW7LcFuKWZZkk/B3mRzbXkgJRouPfqa4+Stv2TEKgNfJsMZbIeYqjfAhZKnUCUSIpqmznFA3RPMRzxu9Hi8pA0obTzDeY7fextL8/uMWC8AQxi/U81cR4KdMiCF5/i0RI2blIz6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DhANDHcR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rZxNVcLY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770823864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KgZLxYej2+Jm/2mAtMCoJI/wRP+Se5cFtNVR14mJ03o=;
	b=DhANDHcRXKNAhk1zfPyKPsBAVJN+dj5Y1b2l+JLcy7wTmTr9tBFywwKzmLE+RwsReP3Vo+
	+yJUrW51LAbujNfZgRQxIh1BFDgRsN2/jPK2R0zpKthPcx/pFJzfaBRct4bBJY9WD7ks0U
	l+ngbRNG3nYvi99F10kbsq8B9WZr1uY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-NS6YsQrCO4y0dPSx50OPKQ-1; Wed, 11 Feb 2026 10:31:03 -0500
X-MC-Unique: NS6YsQrCO4y0dPSx50OPKQ-1
X-Mimecast-MFC-AGG-ID: NS6YsQrCO4y0dPSx50OPKQ_1770823862
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4801c1056c7so13181225e9.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 07:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770823862; x=1771428662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KgZLxYej2+Jm/2mAtMCoJI/wRP+Se5cFtNVR14mJ03o=;
        b=rZxNVcLY8PeTp5JZN8oHpHYQWoH8dCvM9rzDjbxqPLL/t30HMXZYfn6wU4vybPf9MI
         i98fnUi03gjMFaiIQ479B5Z3inDkh70RnFdf1+IFCXcGDJy5T7REcty8KSso4Xo64CJR
         1iNNGlttucjeuwWM5yJgctIY0ooFmeh9bOCSuq9bd4DHunUWxi85Bon2x6fNV5WzzgnI
         +YeiIWJd7yHyqb29PSIlclMiom87GDfDe8Y7vcYhFMoBIQohAsRR60x71jRgWqV2CKBc
         j65ssuAHFqlNQb/8g4m1ygOgPfnU0hgNjWF4mCc3ueM55rmZr+3IHH5EMqLn3BPzTQOZ
         zmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823862; x=1771428662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KgZLxYej2+Jm/2mAtMCoJI/wRP+Se5cFtNVR14mJ03o=;
        b=RMFz3juSud6T2cZpOLDEoEc//zEAcWQpWnFJ/9/cXRTKktQ1EQ/MECw6X0CCLDbo3z
         HJEnbE8PMeM1Sn8aun+psa3j0Z6xBVWT+AAJ/Lciy//AB+4UQpny8V/T8a6LZgoeY8HL
         E6cPTCKYPB9+hmjcKClFi15Kt6q63hXTPO5KE1hpCB7jDcjJRzQlPLV7ZhGUrETcIzRC
         4AGZBLHCaG0FHqoCSBlZDbr8rG3bDR4Fr8fibOB2WZzQI+OplMQrxnUGaxe1/ywI2M8k
         IC4nh2yvbkqSytyR4Y0arwUfffBE1s7qG+shmYnZR/I2yMYhibKak3rc28UXTovPMHps
         EAJg==
X-Forwarded-Encrypted: i=1; AJvYcCVWUXdGFQCLhIjqZPA9eqQqXw24DWfntiF06nXOwjAbsWhoKF2wcTwqCReHdzMzjcNAwG4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgb5Xsmuw1mgScPal+DMC4TzShCBuD+HqBOxZMKjluoW2+Awzs
	wj6Pft4q/GjoBzzOwqFwJLUaXico41vMajNCJ5hSAMTo0Q4GI6nbclmdliti1l8K2vbgjomjcTh
	Zydcxcjpy6EMe+XKj3+f3FFqd70aRNYD9C/zfkSwFEEpCtJr8KGbLarlY1irkKw==
X-Gm-Gg: AZuq6aLV9JL1Due0Vvu/YPZvz5/n7GJi6f9k4ZNwkwLdV4fB66gYTN7eKjip1L0U7LL
	0+XWTfi8RJSxha6VbGB9ABDrcTQ9CkxmqRxh3A+Fa/ofmQIHVJGvjFm3Z8p+B7bxKe+6oTqJ4U+
	Y7SfDMxIhSr+A8b+uXmYE5tIGFf4RLR1xeoB8Af7h+2TLxLExVY9mfdH2WX2MJybDOj/xmYO7Qc
	3/9Zi5sc4tqaxqp9s74XDkMWpyLDxiw1sNfBDEwe8hzauISX6aFulcLdyUJl1vWR06lGOiqH8r9
	Q+HHXoQinpvOi8wCam7mjQS+wsy3h37y0DLYqQiNKeUagyizwQA1ocZubNRhSV0d/k0vkyZJHCy
	+Ra9K53INoCdO1mVRhe53XHnEaOH1vChsGD2NnpS1JbrfQ3QfpnFuZ4nJceJ0YgCsmeaoxMMlJt
	b9UOQoVJfY
X-Received: by 2002:a05:600c:c16d:b0:480:4a90:1b00 with SMTP id 5b1f17b1804b1-4832021605bmr226049995e9.20.1770823861892;
        Wed, 11 Feb 2026 07:31:01 -0800 (PST)
X-Received: by 2002:a05:600c:c16d:b0:480:4a90:1b00 with SMTP id 5b1f17b1804b1-4832021605bmr226049465e9.20.1770823861415;
        Wed, 11 Feb 2026 07:31:01 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d34657sm6448511f8f.6.2026.02.11.07.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:31:00 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v5 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Wed, 11 Feb 2026 16:30:32 +0100
Message-ID: <20260211153032.19327-3-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260211153032.19327-1-sebott@redhat.com>
References: <20260211153032.19327-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70859-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 29E5F125AEE
X-Rspamd-Action: no action

Provide a kvm specific vcpu property to override the default
(as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 docs/system/arm/cpu-features.rst | 11 ++++++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm.c                 | 65 +++++++++++++++++++++++++++++++-
 3 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 37d5dfd15b..50b106f2eb 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -204,6 +204,17 @@ the list of KVM VCPU features and their descriptions.
   the guest scheduler behavior and/or be exposed to the guest
   userspace.
 
+``kvm-psci-version``
+  Set the Power State Coordination Interface (PSCI) firmware ABI version
+  that KVM provides to the guest. By default KVM will use the newest
+  version that it knows about (which is PSCI v1.3 in Linux v6.13).
+
+  You only need to set this if you want to be able to migrate this
+  VM to a host machine running an older kernel that does not
+  recognize the PSCI version that this host's kernel defaults to.
+
+  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.
+
 TCG VCPU Features
 =================
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index e146f7e6c4..d3cfd444e8 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1036,6 +1036,12 @@ struct ArchCPU {
     bool kvm_vtime_dirty;
     uint64_t kvm_vtime;
 
+    /*
+     * Intermediate value used during property parsing.
+     * Once finalized, the value should be read from psci_version.
+     */
+    uint32_t kvm_prop_psci_version;
+
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ded582e0da..6d13cb4f3c 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -485,6 +485,46 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
     ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
 }
 
+typedef struct PSCIVersion {
+    uint32_t number;
+    const char *str;
+} PSCIVersion;
+
+static const PSCIVersion psci_versions[] = {
+    { QEMU_PSCI_VERSION_0_1, "0.1" },
+    { QEMU_PSCI_VERSION_0_2, "0.2" },
+    { QEMU_PSCI_VERSION_1_0, "1.0" },
+    { QEMU_PSCI_VERSION_1_1, "1.1" },
+    { QEMU_PSCI_VERSION_1_2, "1.2" },
+    { QEMU_PSCI_VERSION_1_3, "1.3" },
+};
+
+static char *kvm_get_psci_version(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    for (int i = 0; i < ARRAY_SIZE(psci_versions); i++) {
+        if (psci_versions[i].number == cpu->psci_version)
+            return g_strdup(psci_versions[i].str);
+    }
+
+    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
+}
+
+static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    for (int i = 0; i < ARRAY_SIZE(psci_versions); i++) {
+        if (!strcmp(value, psci_versions[i].str)) {
+            cpu->kvm_prop_psci_version = psci_versions[i].number;
+            return;
+        }
+    }
+
+    error_setg(errp, "Invalid PSCI version.");
+}
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -506,6 +546,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
                              kvm_steal_time_set);
     object_property_set_description(obj, "kvm-steal-time",
                                     "Set off to disable KVM steal time.");
+
+    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
+                            kvm_set_psci_version);
+    object_property_set_description(obj, "kvm-psci-version",
+                                    "Set PSCI version. "
+                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");
 }
 
 bool kvm_arm_pmu_supported(void)
@@ -1976,7 +2022,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (cpu->kvm_prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+        /*
+         * Versions >= v0.2 are backward compatible with v0.2
+         * omit the feature flag for v0.1 .
+         */
         cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
@@ -2015,6 +2066,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->kvm_prop_psci_version) {
+        psciver = cpu->kvm_prop_psci_version;
+        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
+        if (ret) {
+            error_report("KVM in this kernel does not support PSCI version %d.%d",
+                         (int) PSCI_VERSION_MAJOR(psciver),
+                         (int) PSCI_VERSION_MINOR(psciver));
+            error_printf("Consider setting the kvm-psci-version property on the "
+                         "migration source.\n");
+            return ret;
+        }
+    }
     /*
      * KVM reports the exact PSCI version it is implementing via a
      * special sysreg. If it is present, use its contents to determine
-- 
2.52.0



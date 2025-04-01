Return-Path: <kvm+bounces-42288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD06A77426
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 07:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D9D1165567
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 05:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D51D192598;
	Tue,  1 Apr 2025 05:52:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D3742052
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 05:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743486750; cv=none; b=tJx+iRHC1BUo0QtlOKlnvp5cKaZeUeNosqnVe1hj8GTkbXV+U/lwo0Gfln7CELhJZs35pvz/Arvob7ak23ENSfChrZ63x8hsMcbwRMaXBNfCj7z9OGUtC8G1qapR5d6w4S++bX7PEWqmCtObnYEJfSU5JJyRByhC4WdKsLQn0mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743486750; c=relaxed/simple;
	bh=Adtk5Egb+ncfwAKhW4k5FRqk/wZBry6VEy4VKXX/P4o=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=ZlrIsd9WB+6MRmGi4WAfhvdqoQ6J6Q86yZoLIJJyapO1YbmVgNpbWTDCmx7pD2bsbZsDe2ZjoO1z2An0e1ftgZKCDLXogV4fNl/HiljIgCFpieSz+sOKnrQRBZprD2pYoA2Ds1UgkQt1EcAQLYfCUEri3VhRar+w2LknD3AOVPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1743486736-1eb14e18d900240001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id gP0W5X89XsjhBRGA (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 01 Apr 2025 13:52:16 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX3.zhaoxin.com (10.28.252.165) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Tue, 1 Apr
 2025 13:52:16 +0800
Received: from ZXSHMBX3.zhaoxin.com ([fe80::8cc5:5bc6:24ec:65f2]) by
 ZXSHMBX3.zhaoxin.com ([fe80::8cc5:5bc6:24ec:65f2%6]) with mapi id
 15.01.2507.044; Tue, 1 Apr 2025 13:52:16 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [192.168.31.91] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Tue, 1 Apr
 2025 11:35:50 +0800
Message-ID: <65a6e617-8dd8-46ee-b867-931148985e79@zhaoxin.com>
Date: Tue, 1 Apr 2025 11:35:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Dongli Zhang <dongli.zhang@oracle.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>
X-ASG-Orig-Subj: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
CC: <pbonzini@redhat.com>, <mtosatti@redhat.com>, <sandipan.das@amd.com>,
	<babu.moger@amd.com>, <likexu@tencent.com>, <like.xu.linux@gmail.com>,
	<zhenyuw@linux.intel.com>, <groug@kaod.org>, <khorenko@virtuozzo.com>,
	<alexander.ivanov@virtuozzo.com>, <den@virtuozzo.com>,
	<davydov-max@yandex-team.ru>, <xiaoyao.li@intel.com>,
	<dapeng1.mi@linux.intel.com>, <joe.jin@oracle.com>, <ewanhai@zhaoxin.com>,
	<cobechen@zhaoxin.com>, <louisqi@zhaoxin.com>, <liamni@zhaoxin.com>,
	<frankzhu@zhaoxin.com>, <silviazhao@zhaoxin.com>, <zhao1.liu@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
 <8a547bf5-bdd4-4a49-883a-02b4aa0cc92c@zhaoxin.com>
 <84653627-3a20-44fd-8955-a19264bd2348@oracle.com>
 <e3a64575-ab1f-4b6f-a91d-37a862715742@zhaoxin.com>
 <a94487ab-b06d-4df4-92d8-feceeeaf5ec3@oracle.com>
In-Reply-To: <a94487ab-b06d-4df4-92d8-feceeeaf5ec3@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 4/1/2025 1:52:15 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1743486736
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 3842
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.01
X-Barracuda-Spam-Status: No, SCORE=-2.01 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=TRACK_DBX_001
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.139319
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 TRACK_DBX_001          Custom rule TRACK_DBX_001

>> [2] As mentioned in [1], QEMU always sets the vCPU's vendor to match the host's
>> vendor
>> when acceleration (KVM or HVF) is enabled. Therefore, if users want to emulate a
>> Zhaoxin CPU on an Intel host, the vendor must be set manually.Furthermore,
>> should we display a warning to users who enable both vPMU and KVM acceleration
>> but do not manually set the guest vendor when it differs from the host vendor?
> 
> Maybe not? Sometimes I emulate AMD on Intel host, while vendor is still the
> default :)

Okay, handling this situation can be rather complex, so let's keep it simple. I 
have added a dedicated function to capture the intended behavior for potential 
future reference.

Anyway, Thanks for taking Zhaoxin's situation into account, regardless.


+/*
+ * check_vendor_compatibility_and_warn() returns true if the host and
+ * guest vendors are compatible for vPMU virtualization. In addition, if
+ * the guest vendor is not explicitly set in a cross-vendor emulation
+ * scenario (e.g., a Zhaoxin host emulating an Intel guest or vice versa),
+ * it issues a warning.
+ */
+static bool check_vendor_compatibility_and_warn(CPUX86State *env)
+{
+    char host_vendor[CPUID_VENDOR_SZ + 1];
+    uint32_t host_cpuid_vendor1, host_cpuid_vendor2, host_cpuid_vendor3;
+
+    /* Retrieve host vendor info */
+    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
+               &host_cpuid_vendor2);
+    x86_cpu_vendor_words2str(host_vendor, host_cpuid_vendor1,
+                             host_cpuid_vendor2, host_cpuid_vendor3);
+
+    /*
+     * Case A:
+     * If the host vendor is Intel or Zhaoxin and the guest CPU type is
+     * either Intel or Zhaoxin, consider them compatible. However, if a
+     * cross-vendor scenario is detected (e.g., host is Zhaoxin but guest is
+     * Intel, or vice versa) and the guest vendor fields have not been
+     * overridden (i.e., they still match the host), then warn the user.
+     */
+    if ((g_str_equal(host_vendor, CPUID_VENDOR_INTEL) ||
+         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN1) ||
+         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN2)) &&
+        (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)))
+    {
+        if ((g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN1) ||
+             g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN2)) &&
+            IS_INTEL_CPU(env) &&
+            (env->cpuid_vendor1 == host_cpuid_vendor1 &&
+             env->cpuid_vendor2 == host_cpuid_vendor2 &&
+             env->cpuid_vendor3 == host_cpuid_vendor3))
+        {
+            warning_report("vPMU emulation will fail because the guest vendor "
+                            "is not explicitly set. Use '-cpu,vendor=Intel' to "
+                            "emulate Intel vPMU on a Zhaoxin host.");
+        }
+        else if (g_str_equal(host_vendor, CPUID_VENDOR_INTEL) &&
+                 IS_ZHAOXIN_CPU(env) &&
+                 (env->cpuid_vendor1 == host_cpuid_vendor1 &&
+                  env->cpuid_vendor2 == host_cpuid_vendor2 &&
+                  env->cpuid_vendor3 == host_cpuid_vendor3))
+        {
+            warning_report("vPMU emulation will fail because the guest vendor"
+                            "is not explicitly set. Use '-cpu,vendor=Zhaoxin' "
+                            "to emulate Zhaoxin vPMU on an Intel host.");
+        }
+        return true;
+    }
+
+    /*
+     * Case B:
+     * For other CPU types, if the guest vendor fields exactly match the host,
+     * consider them compatible.
+     */
+    if (env->cpuid_vendor1 == host_cpuid_vendor1 &&
+        env->cpuid_vendor2 == host_cpuid_vendor2 &&
+        env->cpuid_vendor3 == host_cpuid_vendor3)
+    {
+        return true;
+    }
+
+    return false;
+}
+


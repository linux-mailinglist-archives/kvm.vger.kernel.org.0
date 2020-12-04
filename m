Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3740C2CECF9
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 12:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgLDLWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 06:22:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729930AbgLDLWT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 06:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607080851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f2/H3RiAz1pLocixmwGuSF5Rzz6qChqweXU5xPialv8=;
        b=g+keMaH2XVYD8gv6xuN4JET8pTPI5qsHGVE3ykCLZI8yiRQDxY3MM0u4gNxJt+WxHZ68iB
        i+Zj5oY6Wf+vaCKJU3eTEq6/KOle/OWrBox7ygpzrqlpVk1C3nJ6Dd2chrtlgIpaI5HpXF
        c85EPmp+TqAtlJ7aaHJb43wKjxOPWhw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-aOvSvrIqM6WjHj7VxLSKlg-1; Fri, 04 Dec 2020 06:20:50 -0500
X-MC-Unique: aOvSvrIqM6WjHj7VxLSKlg-1
Received: by mail-wr1-f70.google.com with SMTP id v1so2411940wri.16
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 03:20:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f2/H3RiAz1pLocixmwGuSF5Rzz6qChqweXU5xPialv8=;
        b=U95ZkgeCm9N57hdD3IxVg/oxWVUYLgZQckadPbPmTJceVCK4DQtcga1VSUnH4XBbKb
         SmKzyprdUDThFCUntU9F1IcERYGlgsnSOszyaZKTXF4aYuTrfyJzfn5vND9/WaLD+jZR
         051bWdkxEjAWIdrEG8uJes2mqX4fZ5R3oI9Yvkqv/hUcu1msLXyVywbbf87+zJxP36Qc
         gkNbvVtZ7bF3dQ2kDUgkFcogGRPqSj42N5avtsLATS05G3U0kfGm4+rRSgqHObtweuiv
         qdunQMtNBBiF+jjcWFHdGqDMO80HHeqqm9ydSo6kzTMuYKno4Ey5e917U+emo/rdFbYX
         yW3Q==
X-Gm-Message-State: AOAM532D+FTxih8QaBxht2snlHzx40J1oRCSyBQ1DaL/ODUE+vSsmvU4
        A1TYdZ93CsiFnjnrjpQrLkWBWj+bfWzFQQFmACfeIYv9M6hCPiXndu1RztuEmpbBp/lpRaOwuE8
        1a+nKpB8mWPQf
X-Received: by 2002:a5d:61cc:: with SMTP id q12mr3443370wrv.395.1607080848924;
        Fri, 04 Dec 2020 03:20:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqwUEbseNrLnggtecxJEVeJHQ/BzfJ2S+msbXTA3EQ17p3ohZbgfmeGfL9ym9CfOKhFzugiw==
X-Received: by 2002:a5d:61cc:: with SMTP id q12mr3443344wrv.395.1607080848668;
        Fri, 04 Dec 2020 03:20:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s13sm2595325wmj.28.2020.12.04.03.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 03:20:47 -0800 (PST)
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <4ff020b446baa06037136ceeb1e66d4eba8ad492.1588711355.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <07c975ec-9319-dbd8-cbfe-61c70588d597@redhat.com>
Date:   Fri, 4 Dec 2020 12:20:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4ff020b446baa06037136ceeb1e66d4eba8ad492.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 23:19, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> for host-side support for SEV live migration. Also add a new custom
> MSR_KVM_SEV_LIVE_MIG_EN for guest to enable the SEV live migration
> feature.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   Documentation/virt/kvm/cpuid.rst     |  5 +++++
>   Documentation/virt/kvm/msr.rst       | 10 ++++++++++
>   arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
>   arch/x86/kvm/svm/sev.c               | 14 ++++++++++++++
>   arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
>   arch/x86/kvm/svm/svm.h               |  2 ++
>   6 files changed, 52 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..0514523e00cd 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -86,6 +86,11 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>                                                 before using paravirtualized
>                                                 sched yield.
>   
> +KVM_FEATURE_SEV_LIVE_MIGRATION    14          guest checks this feature bit before
> +                                              using the page encryption state
> +                                              hypercall to notify the page state
> +                                              change
> +
>   KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                 per-cpu warps are expeced in
>                                                 kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index 33892036672d..7cd7786bbb03 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -319,3 +319,13 @@ data:
>   
>   	KVM guests can request the host not to poll on HLT, for example if
>   	they are performing polling themselves.
> +
> +MSR_KVM_SEV_LIVE_MIG_EN:
> +        0x4b564d06
> +
> +	Control SEV Live Migration features.
> +
> +data:
> +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature.
> +        Bit 1 enables (1) or disables (0) support for SEV Live Migration extensions.
> +        All other bits are reserved.

This doesn't say what the feature is or does, and what the extensions 
are.  As far as I understand bit 0 is a guest->host communication that 
it's properly handling the encryption bitmap.

I applied patches -13, this one a bit changed as follows.

diff --git a/Documentation/virt/kvm/cpuid.rst 
b/Documentation/virt/kvm/cpuid.rst
index cf62162d4be2..7d82d7da3835 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest 
checks this feature bit
                                                 before using extended 
destination
                                                 ID bits in MSI address 
bits 11-5.

+KVM_FEATURE_ENCRYPTED_VM_BIT       16          guest checks this 
feature bit before
+                                               using the page 
encryption state
+                                               hypercall and encrypted VM
+                                               features MSR
+
  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no 
guest-side
                                                 per-cpu warps are 
expected in
                                                 kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..02528bc760b8 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,13 @@ data:
  	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
  	and check if there are more notifications pending. The MSR is available
  	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_ENC_VM_FEATURE:
+        0x4b564d08
+
+	Control encrypted VM features.
+
+data:
+        Bit 0 tells the host that the guest is (1) or is not (0) 
issuing the
+        ``KVM_HC_PAGE_ENC_STATUS`` hypercall to keep the encrypted bitmap
+       up to date.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h 
b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..3dda6e416a70 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -33,6 +33,7 @@
  #define KVM_FEATURE_PV_SCHED_YIELD	13
  #define KVM_FEATURE_ASYNC_PF_INT	14
  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_ENCRYPTED_VM	16

  #define KVM_HINTS_REALTIME      0

@@ -54,6 +55,7 @@
  #define MSR_KVM_POLL_CONTROL	0x4b564d05
  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_ENC_VM_FEATURE	0x4b564d08

  struct kvm_steal_time {
  	__u64 steal;
@@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
  #define KVM_PV_EOI_DISABLED 0x0

+#define KVM_ENC_VM_BITMAP_VALID			(1 << 0)
+
  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fa67f498e838..0673531233da 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1478,6 +1478,17 @@ int svm_page_enc_status_hc(struct kvm *kvm, 
unsigned long gpa,
  	return 0;
  }

+void sev_update_enc_vm_flags(struct kvm *kvm, u64 data)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!sev_guest(kvm))
+		return;
+
+	if (data & KVM_ENC_VM_BITMAP_VALID)
+		sev->live_migration_enabled = true;
+}
+
  int svm_get_page_enc_bitmap(struct kvm *kvm,
  				   struct kvm_page_enc_bitmap *bmap)
  {
@@ -1490,6 +1501,9 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
  	if (!sev_guest(kvm))
  		return -ENOTTY;

+	if (!sev->live_migration_enabled)
+		return -EINVAL;
+
  	gfn_start = bmap->start_gfn;
  	gfn_end = gfn_start + bmap->num_pages;

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 66f7014eaae2..8ac2c5b9c675 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2766,6 +2766,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, 
struct msr_data *msr)
  		svm->msr_decfg = data;
  		break;
  	}
+	case MSR_KVM_ENC_VM_FEATURE:
+		sev_update_enc_vm_flags(vcpu->kvm, data);
+		break;
  	case MSR_IA32_APICBASE:
  		if (kvm_vcpu_apicv_active(vcpu))
  			avic_update_vapic_bar(to_svm(vcpu), data);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 287559b8c5b2..363c3f8d00b7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -66,6 +66,7 @@ struct kvm_sev_info {
  	int fd;			/* SEV device fd */
  	unsigned long pages_locked; /* Number of pages locked */
  	struct list_head regions_list;  /* List of registered regions */
+	bool live_migration_enabled;
  	unsigned long *page_enc_bmap;
  	unsigned long page_enc_bmap_size;
  };
@@ -504,5 +505,6 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned 
long gpa,
  				  unsigned long npages, unsigned long enc);
  int svm_get_page_enc_bitmap(struct kvm *kvm, struct 
kvm_page_enc_bitmap *bmap);
  int svm_set_page_enc_bitmap(struct kvm *kvm, struct 
kvm_page_enc_bitmap *bmap);
+void sev_update_enc_vm_flags(struct kvm *kvm, u64 data);

  #endif

Paolo


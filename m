Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEE8275E0D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIWQ7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:59:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbgIWQ7n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 12:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600880381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vmVARHYAsE9tPU6eUJfulnvnl82Jvse1QKnk4N0AG3M=;
        b=Ez50VuX6Nib6D3yYXHbxafI0WdZd9KXkDmVLyyOks/vRrh53PBoX99qh/TA+yvvsEpE0zm
        +pKKHmV9ZdZHpFslXZENpzP9j48uHJfLKP7UBLdurVh0XZpV2FybkGs+vWHA2vnTxE+nNT
        cuG/XFa0dB+SzOwNlDRlV+fqhrKz0Ko=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-r1GhsADeMie6c8AaL7uibg-1; Wed, 23 Sep 2020 12:59:40 -0400
X-MC-Unique: r1GhsADeMie6c8AaL7uibg-1
Received: by mail-wr1-f70.google.com with SMTP id d9so71413wrv.16
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 09:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vmVARHYAsE9tPU6eUJfulnvnl82Jvse1QKnk4N0AG3M=;
        b=f6toFHZ8J0tfxR7sBEdOHzW/Zh4UI+Gc9vQ9yRlC+rVgiSDxuZj1TWjTlGAhkoiVB4
         UtEvxUn1oWF3p0YXAhlkkvyLWoNNaNWDSiiCJZOXwxayqoSNEY0zGRHg3Rq+g21UssK4
         9E5u4rXaYNkWXvjebULuv8Eos0HcC/y32Bte6aFifv602Yyf6vL/eKOFb7ajFIZgYA09
         btcxx+5KZIOc+gfISMAZUpTgB/Kl2c94rvNXdsoYDUxR2DD/dTGAq8YCTEoUyniWkOZm
         YviHFXgwF4kfGVn2j+sbfZ49fUI6d7R2LixchoiRTQ5F2ufkag3Y++k+e0SgGlPHkyjP
         2ffA==
X-Gm-Message-State: AOAM531z4mhL2sp6iODeas41sLuRftkcmFvU37om4njbBL34X/cgVRgk
        iOOf4b+uNvB08Hm9rq9dyUESiZwAJ+T4ep/N1BTlvA3RReY7wAar8PVTMWFw3gbN0rJXFehU8k0
        LLyyA2iArWcc6
X-Received: by 2002:adf:dd82:: with SMTP id x2mr609807wrl.419.1600880378590;
        Wed, 23 Sep 2020 09:59:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCuDHXBEAcHyIB5Vvs3lEyQ6sVJqsATi+lSmVZHEx6qix26/NPEU4yz7D8Ev4AcSVYp4csdA==
X-Received: by 2002:adf:dd82:: with SMTP id x2mr609777wrl.419.1600880378347;
        Wed, 23 Sep 2020 09:59:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id x10sm401353wmi.37.2020.09.23.09.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 09:59:37 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Mark SEV launch secret pages as dirty.
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Cfir Cohen <cfir@google.com>
Cc:     "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>,
        Singh Brijesh <brijesh.singh@amd.com>,
        Grimm Jon <Jon.Grimm@amd.com>,
        David Rientjes <rientjes@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20200807012303.3769170-1-cfir@google.com>
 <20200919045505.GC21189@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5ac77c46-88b4-df45-4f02-72adfb096262@redhat.com>
Date:   Wed, 23 Sep 2020 18:59:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200919045505.GC21189@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/09/20 06:55, Sean Christopherson wrote:
> Side topic, while I love the comment (I do, honestly) regarding in-place
> encryption, this is the fourth? instance of the same 4-line comment (6 lines
> if you count the /* and */.  Maybe it's time to do something like
> 
> 	/* LAUNCH_SECRET does in-place encryption, see sev_clflush_pages(). */
> 
> and then have the main comment in sev_clflush_pages().  With the addition of
> X86_FEATURE_SME_COHERENT, there's even a fantastic location for the comment:

Two of the three instances are a bit different though.  What about this
which at least shortens the comment to 2 fewer lines:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bb0e89c79a04..7b11546e65ba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -446,10 +446,8 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 
 	/*
-	 * The LAUNCH_UPDATE command will perform in-place encryption of the
-	 * memory content (i.e it will write the same memory region with C=1).
-	 * It's possible that the cache may contain the data with C=0, i.e.,
-	 * unencrypted so invalidate it first.
+	 * Flush before LAUNCH_UPDATE encrypts pages in place, in case the cache
+	 * contains the data that was written unencrypted.
 	 */
 	sev_clflush_pages(inpages, npages);
 
@@ -805,10 +803,8 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		}
 
 		/*
-		 * The DBG_{DE,EN}CRYPT commands will perform {dec,en}cryption of the
-		 * memory content (i.e it will write the same memory region with C=1).
-		 * It's possible that the cache may contain the data with C=0, i.e.,
-		 * unencrypted so invalidate it first.
+		 * Flush before DBG_{DE,EN}CRYPT reads or modifies the pages, flush the
+		 * destination too in case the cache contains its current data.
 		 */
 		sev_clflush_pages(src_p, 1);
 		sev_clflush_pages(dst_p, 1);
@@ -870,10 +866,8 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return PTR_ERR(pages);
 
 	/*
-	 * The LAUNCH_SECRET command will perform in-place encryption of the
-	 * memory content (i.e it will write the same memory region with C=1).
-	 * It's possible that the cache may contain the data with C=0, i.e.,
-	 * unencrypted so invalidate it first.
+	 * Flush before LAUNCH_SECRET encrypts pages in place, in case the cache
+	 * contains the data that was written unencrypted.
 	 */
 	sev_clflush_pages(pages, n);
 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E885674388
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjASUgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjASUgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:36:08 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164B9966ED
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:36:05 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 78so2509780pgb.8
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=geNr1E6VfBEr6rNDuNt5xZRGvMS8AANNdGRpDjlpRuU=;
        b=Iz5otatIxfEwMlDKOapnMMO592tFYuufDvsRgepbG9Lwd4QGlufz5Dl1lYejAJruJq
         33/30rrzenH9TRxIlCwvCDHh1iqm1pIZOAxmy+FKb6tZhdlMuWznkISuuSDd7d0oq6zg
         RJ7JJJq26Mrw5WNdK8ic6xb9E74jiaVpl3Tes0OdEvZoxOwjsuEbFeM08H0sgxXZe9U1
         zr0+8YSVECHB0GYTME1UzvOcbTbZ2dRJIPlOZ6euEk6w8iFtuAW+Cv9xFFz2N31nMN7G
         ZcGaeLWfARNbBlBsNW+Cq8XSbrVzVMR2/TlJZpqqsj3z1nvE3nsLxTGbaodzsE93w9cA
         QGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=geNr1E6VfBEr6rNDuNt5xZRGvMS8AANNdGRpDjlpRuU=;
        b=a29TD0ihdrX6jO8Oufw6n66vrbkkSFmXhV+DBO7Y9bwpqRkSqIrYaa3dpLHAtxdA4P
         /HDP/ly+63xE5r56IHur36mq+F0CFK2hatq797JvDaLM8YWPUgtdYXBydEu1LLBOiiZi
         byJMBzMPGUPaaCXr2SibnupjxUMfWVMnXPBgULdKkQXJliQI3mtYduM1QdaLz3CN+Ts7
         +SGYcW39oojx9W00FQwWH2G3Da2WtpIttgl691pjMjriMj9cIPUBFqY6hQ6kmRytahEY
         qmrBWD6GLfVX57kp2XFKqqrx2d8wikvgzQAHMVMA/vfcfMl2H2epI9fzVlbsJWics3Ey
         uxCg==
X-Gm-Message-State: AFqh2kpdqoRbdC6Mt/ifgeG5lHu1AKRisSm0FOEfqxJa17PwLO+4PCSv
        yKe1qWT/Mq2l3cY1DuDbKFgps0x5EYJJFC/Q9o91tw==
X-Google-Smtp-Source: AMrXdXuXWIkBvjeABJVhFjJg/BU1DXB+KocDp8hkIozqTT9DBpOmCElWzlT4csdohivH2Pe8ccTDvANtE0IQdxcA/rw=
X-Received: by 2002:a63:2447:0:b0:4be:c5ec:93e1 with SMTP id
 k68-20020a632447000000b004bec5ec93e1mr1074292pgk.213.1674160564313; Thu, 19
 Jan 2023 12:36:04 -0800 (PST)
MIME-Version: 1.0
References: <20221214194056.161492-1-michael.roth@amd.com> <20221214194056.161492-53-michael.roth@amd.com>
In-Reply-To: <20221214194056.161492-53-michael.roth@amd.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Thu, 19 Jan 2023 12:35:52 -0800
Message-ID: <CAAH4kHYoWtM=Xe0kgmtKw01-45DefEikdLz0qUJRRMLdZHzkwA@mail.gmail.com>
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-16.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +
> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{

Both regular,

> +
> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{

and extended guest requests should be subject to rate limiting, since
they take a lock on the shared resource that is the AMD-SP (psp?). I
proposed a mechanism with empirically chosen defaults in

[PATCH v2 0/2] kvm: sev: Add SNP guest request throttling
[PATCH v2 1/2] kvm: sev: Add SEV-SNP guest request throttling
[PATCH v2 2/2] kvm: sev: If ccp is busy, report throttled to guest

http://129.79.113.48/hypermail/linux/kernel/2211.2/03107.html
http://129.79.113.48/hypermail/linux/kernel/2211.2/03110.html
http://129.79.113.48/hypermail/linux/kernel/2211.2/03111.html

But I don't see these on lore. Would you like me to repost these?

-- 
-Dionna Glaze, PhD (she/her)

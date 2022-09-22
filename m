Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF055E6FAA
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 00:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiIVWXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 18:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiIVWXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 18:23:14 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FEB113B5A
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:22:22 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id c7so10535040pgt.11
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aw1uFe/KmsNaxOq1kOqpDl2z0N4SrfAtYbjvbg4KNlA=;
        b=fTDhXkfLZvNkuL4IaGwGto6ivJHDG5foWXr5fgBLomdHZi/ywaW10ym20Gfyr41fW/
         88NnUq6bEGanHt4XE7wkcUDOp66fBEsgXVr4ZrD69bQJ4iLIjUCR9fhTsHG2L7s8yW2W
         LjPS9U+YyX857M3y7lxVbFLz9Q76RY7/dh1tZSO6eexKvWnRib+f7yznEn0ZDBv4yP/5
         0AzxzU3pvftuHszNx8a1zCAn82Y4eoP3M6A/8OqpGr9p4iyuQsgw3/8kvaYaiS1HFPlR
         sgrr/g3vxZ4d9xbAp3jsc1jM8a8L+OdF6lx/WBATWRgUGpVBG5qO8QyWN4tlw8oXSbgf
         vheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=aw1uFe/KmsNaxOq1kOqpDl2z0N4SrfAtYbjvbg4KNlA=;
        b=0/qjfH3VhSLTFH9qfracp4GEvSdlroZ5KowMDVgktq+EV5xnvy1aj8iXxFHLKvezC/
         opiZgw2D96t4XHZbix3gcU/Ry0PA1v37Hqips5dtVhhWpsOhrTyVX37yAtDDuHE99lnd
         Wz0vzRHNJ5MCoVosGbiOW4/Mw5vPPS/lCie/LEjzlYVlX9kzBBnTcnbp8f+cmoWrrO6r
         fUMw6pvt2ctoliVwcLuUl05CO+5mDPnjzpWS4vv0lxYJaIr6woFegh7qcKxDmStmb/JN
         Y0nJ4kTILPCGroqAH7x5LVqBgMFRzkAxjdNeEIxwvqOTRkp7BdtIS9sQh+q/lg/JSY7d
         hxWg==
X-Gm-Message-State: ACrzQf3KJdn6TVxutfX3vd4ZFWPFVrW4M2FKw9tQ+Hn5rtjogsxmZYQX
        7KB3UuJL2TdPyHRSv9bKVcH7xw==
X-Google-Smtp-Source: AMsMyM4C0qxXvQoAPen0v6DPpFKOMgb3BmpkvduhGCN4+7foiW2UvD9UGJ8hJhBE8B2GgNaJKhUlmw==
X-Received: by 2002:a05:6a00:170b:b0:547:3e11:914f with SMTP id h11-20020a056a00170b00b005473e11914fmr5865458pfc.34.1663885331265;
        Thu, 22 Sep 2022 15:22:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o64-20020a625a43000000b0053e9d14e51asm4953732pfb.98.2022.09.22.15.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:22:10 -0700 (PDT)
Date:   Thu, 22 Sep 2022 22:22:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86/hyperv: Move VMCB enlightenment definitions to
 hyperv-tlfs.h
Message-ID: <YyzgD0xp/Ki9a3jK@google.com>
References: <20220921201607.3156750-1-seanjc@google.com>
 <20220921201607.3156750-2-seanjc@google.com>
 <BYAPR21MB1688D04068DBA520366DA205D74E9@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB1688D04068DBA520366DA205D74E9@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, Michael Kelley (LINUX) wrote:
> From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, September 21, 2022 1:16 PM
> > 
> > Move Hyper-V's VMCB enlightenment definitions to the TLFS header; the
> > definitions come directly from the TLFS[*], not from KVM.
> > 
> > No functional change intended.
> > 
> > [*] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_svm_enlightened_vmcb_fields> 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/hyperv-tlfs.h | 22 +++++++++++++++++++
> >  arch/x86/kvm/svm/hyperv.h          | 35 ------------------------------
> >  arch/x86/kvm/svm/svm_onhyperv.h    |  3 ++-
> >  3 files changed, 24 insertions(+), 36 deletions(-)
> >  delete mode 100644 arch/x86/kvm/svm/hyperv.h
> > 
> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> > index 0a9407dc0859..4c4f81daf5a2 100644
> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > @@ -584,6 +584,28 @@ struct hv_enlightened_vmcs {
> > 
> >  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL			0xFFFF
> > 
> > +/*
> > + * Hyper-V uses the software reserved 32 bytes in VMCB control area to expose
> > + * SVM enlightenments to guests.
> > + */
> > +struct hv_enlightenments {
> > +	struct __packed hv_enlightenments_control {
> > +		u32 nested_flush_hypercall:1;
> > +		u32 msr_bitmap:1;
> > +		u32 enlightened_npt_tlb: 1;
> > +		u32 reserved:29;
> > +	} __packed hv_enlightenments_control;
> > +	u32 hv_vp_id;
> > +	u64 hv_vm_id;
> > +	u64 partition_assist_page;
> > +	u64 reserved;
> > +} __packed;
> > +
> > +/*
> > + * Hyper-V uses the software reserved clean bit in VMCB.
> > + */
> > +#define VMCB_HV_NESTED_ENLIGHTENMENTS		31
> 
> Is it feasible to change this identifier so it starts with HV_ like
> everything else in this source code file, such as
> HV_VMCB_NESTED_ENLIGHTENMENTS?  It doesn't look like it is
> used in very many places.  

Most definitely, IIRC it's used in only one spot.

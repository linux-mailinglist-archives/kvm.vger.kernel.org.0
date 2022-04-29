Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FCA5153EE
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380123AbiD2SvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiD2SvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:51:01 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C5A8BE39
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:47:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fv2so7836127pjb.4
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eF2Vsl1Y+sSmbDFKvxvLG8OQAc2P8BqrkxARZmIJo/4=;
        b=UaXK0qek/m3KBku94FiR2aCpLAmc5L7lHG00+M/6bHi2MEYsMwwXqvgB2pRRMk14wg
         s6tblUC23UdGhOat3IEPEcSOpJDcOMrCdHM58Mw8ZXum5+ZuoTGa7Xk2q1eRJpiyeRay
         Hep4LWc+YYOikH03Cqom/UkSCzLEu3MDszrqmo3ssDuL1liGDgvRSpq38S11WoniJNab
         1sovPccL6OxSpAGgoV8egZ1SiuVmGbinm4i5byzEsnqhUZt4Tus1ISfCed5wKrxemRSd
         rIElvttjQpwC9+cRUf0seywgw+zpDqfTHFTglZJ+aTXFUBhYdLoJWiP6A2LOEa9Euo+r
         dFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eF2Vsl1Y+sSmbDFKvxvLG8OQAc2P8BqrkxARZmIJo/4=;
        b=Wf+HchWCKZi2f7BINrNR5JSR3Sv9aEMhc0PIlJcRZJHx8DakRXdvQDzBgJ+zzPXemS
         kUWg9DkCD+pCZn1yCisl3l9r9MSe/sLSkcSwKy14t1SOnFsdJchgrSngpK4kMzsxTJ/z
         8ygDHlSvZnLj89J7hVNUO6JMQ/IwPaf5LNeBvOhUTPlHAQ097AaqlXj+p7U4Z3dav10S
         jP1lOF9mOBUa02CQy6UXk6fCBYUC7DVZj/iWWUWu6cHmQrqGW3BH6+gL53zthXCecX2r
         slvH/0GXh0P+T728pI+p6A255Ang/vWxJPD3ocYd9JWO8O2Wu+VnRG6wUlpYfoWVYtew
         yAZw==
X-Gm-Message-State: AOAM533cQSvful0VdNbPl/DTDDORCng3nBIth44FjcWE6Oc22L8rC62b
        w6+/TXeg4X2BElmq7F5zBLGprlbLNzHVJR+XlOJhdw==
X-Google-Smtp-Source: ABdhPJyI5QgAmrNdhx4aroprhMSjkSXeHnyeBO/jtZgb1InUac6OW3lRr7VO74ETA83tRzss8c9IRukmCKSKSvVwNek=
X-Received: by 2002:a17:902:ea57:b0:15a:6173:87dd with SMTP id
 r23-20020a170902ea5700b0015a617387ddmr437403plg.147.1651258062096; Fri, 29
 Apr 2022 11:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
 <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
 <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
 <92af7b22-fa8a-5d42-ae15-8526abfd2622@intel.com> <CAPcyv4iG977DErCfYTqhVzuZqjtqFHK3smnaOpO3p+EbxfvXcQ@mail.gmail.com>
 <4a5143cc-3102-5e30-08b4-c07e44f1a2fc@intel.com> <CAPcyv4i6X6ODNbOnT7+NEzpicLS4m9bNDybZLvN3gqXFTTf=mg@mail.gmail.com>
 <4d0c7316-3564-ef27-1113-042019d583dc@intel.com>
In-Reply-To: <4d0c7316-3564-ef27-1113-042019d583dc@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 29 Apr 2022 11:47:31 -0700
Message-ID: <CAPcyv4gYw3k4YMEV1E26fMx-GNCNCb+zJDERfhieCrROWv_Jxg@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 11:34 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 4/29/22 10:48, Dan Williams wrote:
> >> But, neither of those really help with, say, a device-DAX mapping of
> >> TDX-*IN*capable memory handed to KVM.  The "new syscall" would just
> >> throw up its hands and leave users with the same result: TDX can't be
> >> used.  The new sysfs ABI for NUMA nodes wouldn't clearly apply to
> >> device-DAX because they don't respect the NUMA policy ABI.
> > They do have "target_node" attributes to associate node specific
> > metadata, and could certainly express target_node capabilities in its
> > own ABI. Then it's just a matter of making pfn_to_nid() do the right
> > thing so KVM kernel side can validate the capabilities of all inbound
> > pfns.
>
> Let's walk through how this would work with today's kernel on tomorrow's
> hardware, without KVM validating PFNs:
>
> 1. daxaddr mmap("/dev/dax1234")
> 2. kvmfd = open("/dev/kvm")
> 3. ioctl(KVM_SET_USER_MEMORY_REGION, { daxaddr };

At least for a file backed mapping the capability lookup could be done
here, no need to wait for the fault.

> 4. guest starts running
> 5. guest touches 'daxaddr'
> 6. Page fault handler maps 'daxaddr'
> 7. KVM finds new 'daxaddr' PTE
> 8. TDX code tries to add physical address to Secure-EPT
> 9. TDX "SEAMCALL" fails because page is not convertible
> 10. Guest dies
>
> All we can do to improve on that is call something that pledges to only
> map convertible memory at 'daxaddr'.  We can't *actually* validate the
> physical addresses at mmap() time or even
> KVM_SET_USER_MEMORY_REGION-time because the memory might not have been
> allocated.
>
> Those pledges are hard for anonymous memory though.  To fulfill the
> pledge, we not only have to validate that the NUMA policy is compatible
> at KVM_SET_USER_MEMORY_REGION, we also need to decline changes to the
> policy that might undermine the pledge.

I think it's less that the kernel needs to enforce a pledge and more
that an interface is needed to communicate the guest death reason.
I.e. "here is the impossible thing you asked for, next time set this
policy to avoid this problem".

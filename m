Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F413160B153
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 18:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiJXQT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 12:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiJXQR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 12:17:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4898819283
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 08:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666623765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kJLevlRI7qkidKbiRGpfiyu/SGbqbKCFl4PdvjuRV+o=;
        b=OuQz5Uvt9Mj6I7u8lmH/XQotGvd5AhYMYRQw+XaS5IFYOlcgJF6TWvea5joFwQW+1ueyoc
        FsmAv001JBkmLZBx57rATT88ZwDPCAkjQ0Inv0s63udYckA8uveyQ3Uo2oNNLLP6d5tZEU
        hQkNfQe2NBs2Y6h8Tcml4PwJb/H6ECM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-294-W7CVMqcVN0OtskAYRzsPbQ-1; Mon, 24 Oct 2022 08:46:29 -0400
X-MC-Unique: W7CVMqcVN0OtskAYRzsPbQ-1
Received: by mail-qv1-f69.google.com with SMTP id nn2-20020a056214358200b004bb7bc3dfdcso616693qvb.23
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kJLevlRI7qkidKbiRGpfiyu/SGbqbKCFl4PdvjuRV+o=;
        b=l8NeTgWhvUyw8MzDAuZ/aQNoHr0+Ju8W/oAkzGuBGHhjNocQRCF6R+fn5qWN27ng6v
         /o3yppgq0I2lqsbyXJpHcrakzPcZUC9KR5mbPbMxnN4I7zHGq6fG0ssSpFotuzDK4SCp
         SX8ZFIFmqb3K4QkF5Wet9soFZsQaDziP8/nU8JCMOMszV3odBs5uzBLB1ZR/a9ImyNPl
         /pPMMZFxgYwr6fo9JBCuVLZkK7mvbfenUiOuDeIO7ssfmx3ZSlmbm5tGHKdlC9+8gMQs
         g+HjjlfRYwsoMB4DcG4eQOh+STZIPTUy0VznKptQ4OHJf775eqBWce+pg1s9BBPep0IY
         x2jg==
X-Gm-Message-State: ACrzQf02tDbNi8q+DjAwkgkBgonC157BQShjGlb3JLJ1+Iv4elWDsIfR
        g56O4i+EUyCGI1NXEB5tbmvPeVxij5imK61vllrDU37/kXD2O1xnl98RXjHf62qLiYM2thDzA0/
        vRjpGb6tK2GBU
X-Received: by 2002:a05:622a:4d4:b0:39c:7e8c:d740 with SMTP id q20-20020a05622a04d400b0039c7e8cd740mr27066039qtx.282.1666615589450;
        Mon, 24 Oct 2022 05:46:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM46l/etuyzT3kwqE/IoQtjDlN+t68O/qNpb0SCkIYn1Kq7zs70IznbrKroN1e2umvI1efcntg==
X-Received: by 2002:a05:622a:4d4:b0:39c:7e8c:d740 with SMTP id q20-20020a05622a04d400b0039c7e8cd740mr27066022qtx.282.1666615589178;
        Mon, 24 Oct 2022 05:46:29 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id de38-20020a05620a372600b006ce30a5f892sm15132794qkb.102.2022.10.24.05.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:46:28 -0700 (PDT)
Message-ID: <8c48e5254d8bff06bc78f5ffb4e63023911ef1fe.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 13/16] svm: move vmcb_ident to svm_lib.c
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:46:26 +0300
In-Reply-To: <Y1GVTMo5/GGmx53U@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-14-mlevitsk@redhat.com>
         <Y1GVTMo5/GGmx53U@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 18:37 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> 
> Changelog please.  
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  lib/x86/svm_lib.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/x86/svm_lib.h |  4 ++++
> 
> What about calling these simply svm.{c,h} and renaming x86/svm.{c,h} to something
> like svm_common.{c,h}?  Long term, it would be wonderful to rid of x86/svm.{c,h}
> by genericizing the test framework, e.g. there's a ton of duplicate code between
> SVM and VMX.

Makes sense.


> 
> >  x86/svm.c         | 54 -----------------------------------------------
> >  x86/svm.h         |  1 -
> >  4 files changed, 58 insertions(+), 55 deletions(-)
> > 
> > diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
> > index 9e82e363..2b067c65 100644
> > --- a/lib/x86/svm_lib.c
> > +++ b/lib/x86/svm_lib.c
> > @@ -103,3 +103,57 @@ void setup_svm(void)
> >  
> >         setup_npt();
> >  }
> > +
> > +void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> > +                        u64 base, u32 limit, u32 attr)
> 
> Funky indentation and wrap.

> 
> void vmcb_set_seg(struct vmcb_seg *seg, u16 selector, u64 base, u32 limit,
>                   u32 attr)
> 
> > +{
> > +       seg->selector = selector;
> > +       seg->attrib = attr;
> > +       seg->limit = limit;
> > +       seg->base = base;
> > +}
> > +
> > +void vmcb_ident(struct vmcb *vmcb)
> > +{
> > +       u64 vmcb_phys = virt_to_phys(vmcb);
> > +       struct vmcb_save_area *save = &vmcb->save;
> > +       struct vmcb_control_area *ctrl = &vmcb->control;
> > +       u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> 
> Ugh, a #define for '3' and '9' (in lib/x86/desc.h?) would be nice, but that can
> be left for another day/patch.
Exactly.

> 
> > +               | SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
> 
> Pre-existing mess, but can you move the '|' to the previous line?  And align the
> code?
> 
> > +       u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> > +               | SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
> 
> > on the previous line.

OK.
> 
>         u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK |
>                             SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
>         u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK |
>                             SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
> 


Best regards,
	Maxim Levitsky


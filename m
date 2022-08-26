Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985215A2106
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 08:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245062AbiHZGoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 02:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbiHZGoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 02:44:22 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDF4D1260;
        Thu, 25 Aug 2022 23:44:21 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ds12-20020a17090b08cc00b001fae6343d9fso7213257pjb.0;
        Thu, 25 Aug 2022 23:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uj3gozxe1gCyb2bIziJCE5C5mp6iXyEUe836YmXwevE=;
        b=Q4tkonXYl+lbcTKYBVtnzj/5vghRdqtwkQnFr85jVRoA67R4lZi3AcMGvEKsYPK4zn
         WAa7udtoVIK2N+mpSdHkwuPlzI7vy7319QYczCAbcP8T/fL90gsxatMNFNJBTQiH/luq
         5fGRzPm9i6037skm8XlKRbOqhvs0V+F9O8LBl1focyUJjBUGo/aw3b7zqh4uIciIkr9P
         fzHJ3+JR5juPHo2Og1TJlIxQX8qQGJjMjYx3twsmotPnJHIjsiqYLhFZVEc34LwEEEmJ
         MibYrAC2MNveE2NxUYCR8aOpc/JurU1NQ8p6Oq/93qZdWYjkySW68Kwiy8KXRSoLwEbw
         v5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uj3gozxe1gCyb2bIziJCE5C5mp6iXyEUe836YmXwevE=;
        b=vf78Ko4kCJ+Yib2KsFuuSANhe/QXZkaH43teNTfvOSZYzN4BSmMc9NFyKSHUEpndgp
         XyP34CSxP+VDXdniHLVTRskFf2dWs4aRdLxMQsRJB78XjcbNmu6AsEZ/9QL8xWDtKjTS
         yJs5EMgOUU5Dvcgl21MVpek4jhv1HUc4PjyD2N6nXL0DKU9g5tLzZh2nbqJeqEV7ygw9
         pCLl8ZIIZIgmVJ/kwFyZWhroNbOHHgE63QAmWWZO+T4FS8nofE3RUxnWk7f5KUaC51nA
         hZGVfGT5fRG3cNmsS+NjWTLqbUIorMAXfEfpRUvub6aB+06pxLQW46rnUGHo5eY59Wej
         n+SQ==
X-Gm-Message-State: ACgBeo1UflTyz25CpYfrVf6sazvUFYBMTG48J1hfFlmoDXBJ37+/zmCE
        PJS45GOBdbRqX7lXUU6PGi0=
X-Google-Smtp-Source: AA6agR55luo1gonaYM998/0zeKpNAOHtO1nUdPA4yxxPpmSW8t677Omq57Ht4ilqKXiORaycxxO1MQ==
X-Received: by 2002:a17:902:f542:b0:173:4136:83cb with SMTP id h2-20020a170902f54200b00173413683cbmr2414665plf.4.1661496260795;
        Thu, 25 Aug 2022 23:44:20 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id j17-20020a170903029100b00172ba718ed4sm717586plr.138.2022.08.25.23.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 23:44:18 -0700 (PDT)
Date:   Thu, 25 Aug 2022 23:44:18 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 020/103] KVM: TDX: create/destroy VM structure
Message-ID: <20220826064418.GF2538772@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <810ce6dbd0330f06a80e05afa0a068b5f5b332f3.1659854790.git.isaku.yamahata@intel.com>
 <CAAYXXYzxDEG20jbasFB5yi1RmKCn+OOChfFiGjdfQGjzPze5Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAYXXYzxDEG20jbasFB5yi1RmKCn+OOChfFiGjdfQGjzPze5Ug@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022 at 05:53:00PM -0700,
Erdem Aktas <erdemaktas@google.com> wrote:

> On Sun, Aug 7, 2022 at 3:03 PM <isaku.yamahata@intel.com> wrote:

> > +static void tdx_clear_page(unsigned long page)
> > +{
> > +       const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > +       unsigned long i;
> > +
> > +       /*
> > +        * Zeroing the page is only necessary for systems with MKTME-i:
> > +        * when re-assign one page from old keyid to a new keyid, MOVDIR64B is
> > +        * required to clear/write the page with new keyid to prevent integrity
> > +        * error when read on the page with new keyid.
> > +        */
> 
> Are we saying that we do not need to use MOVDIR64B to clear pages with Li?

Yes. TDX module spec, Table 15.3: Checks on Memory Reads in Li mode says that
read with shared HKID doesn't result in #MC.  Read of poisoned cache line is
another story, though.


> > +       if (!static_cpu_has(X86_FEATURE_MOVDIR64B))
> > +               return;
> > +
> > +       for (i = 0; i < 4096; i += 64)
> > +               /* MOVDIR64B [rdx], es:rdi */
> > +               asm (".byte 0x66, 0x0f, 0x38, 0xf8, 0x3a"
> > +                    : : "d" (zero_page), "D" (page + i) : "memory");
> > +}
> 
> According to the Software Developer Manual, mfence is required for a
> strong ordering on stores. Should we not use mfence here?

Right. I'll add __mb(). thanks for catching it.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

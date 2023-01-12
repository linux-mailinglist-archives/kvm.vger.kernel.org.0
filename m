Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D18667A9F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbjALQVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbjALQVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:21:02 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04B14859B;
        Thu, 12 Jan 2023 08:16:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so2551270pjm.1;
        Thu, 12 Jan 2023 08:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DBBLTT2sIjW9Q0XUiwmmyTSInSBSwqlwXHfPeRyBv3U=;
        b=Ue1dsaX70SYX1XPcMa9mW3vbf3mR49gZ3pdcwBUYBN6k5vtyHelxWkYLhyZHtmxeDD
         DE6vYXFKNDFDmmvf3wCdLmbez9RvNDm39Z0Qm6wlrFZw+Wn0jroI4RTkkAB7Nz+h7XPJ
         FsxA5BLcLbmAZcZ2ENR1uZ1seM22ULQpZZd0upqPfc7wHBJVwdGh4ZFUEEXgW9+RHgpk
         k5SfNCfJS7lQ4oZU3h4AX245k5tZoTUr7XYDDou9VBNrfW9P8H0CZk5xXNBnJ8CYOxpZ
         pMg+oTFH9KKpPKJJZZMlBa86sU+j3jeRWLDOKlb6I7jI2YvkC1uXmTWwVyaQ52unv8/5
         tbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBBLTT2sIjW9Q0XUiwmmyTSInSBSwqlwXHfPeRyBv3U=;
        b=tRt0NYaFL2LazCEDjSluyLqyh+mLiuh46QIN5svKSKp1YAayUPDLufKzj0qesqEvUu
         UmHu2DHg4tIPUsNb5Ke1bHHMMX8Hnm1FDJOT8gUOvlg6sieFuwG7952feNkzmSp7hIoZ
         wuhUGa1ym2KpHKkzF23kmtfuG0uK3jBsc+oo2pAwOyjvgwPCa+7CJs+K2dUvxJ/GYJiZ
         QpdeBuOL5jVeCHHiWk+nZ1dEcmUm5p5nFiBs6YAIZI+xeblwvkE9QiS+CTr4bxFmu0+m
         F50tWSZ2FTxMurnVRaGHGJ93SA0EyIZDm4BNgcbJy2ggzmom3rw1tN0F2KSF1OIDmCv3
         5IgQ==
X-Gm-Message-State: AFqh2kqEm27V7LJ0b4F2NCp61rVr4QbnD+7aJSm2E/jUuSm11XmWVvlo
        1lym0DBTPBZmgEtLCBhhODc=
X-Google-Smtp-Source: AMrXdXuDObR/S7J8lEU1smec6QYXqIEJuNxr+pe0zlCdb3ApXyvkUCpbEIgrIgUbOaHY+PUDORrS0w==
X-Received: by 2002:a17:902:ecce:b0:192:b16b:8e49 with SMTP id a14-20020a170902ecce00b00192b16b8e49mr63431010plh.43.1673540196962;
        Thu, 12 Jan 2023 08:16:36 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902f54400b00192b93a6ce4sm12491527plf.86.2023.01.12.08.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 08:16:36 -0800 (PST)
Date:   Thu, 12 Jan 2023 08:16:34 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wang, Lei" <lei4.wang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 000/108] KVM TDX basic feature support
Message-ID: <20230112161634.GD2034518@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <44e77307-8c49-e350-49e4-d5fa3261db27@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <44e77307-8c49-e350-49e4-d5fa3261db27@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023 at 04:26:59PM +0800,
"Wang, Lei" <lei4.wang@intel.com> wrote:

> On 10/30/2022 2:22 PM, isaku.yamahata@intel.com wrote:
> 
> > ** Detecting the TDX module readiness.
> > TDX host patch series implements the detection of the TDX module availability
> > and its initialization so that KVM can use it.  Also it manages Host KeyID
> > (HKID) assigned to guest TD.
> > The assumed APIs the TDX host patch series provides are
> > - int seamrr_enabled()
> >   Check if required cpu feature (SEAM mode) is available. This only check CPU
> >   feature availability.  At this point, the TDX module may not be ready for KVM
> >   to use.
> > - int init_tdx(void);
> >   Initialization of TDX module so that the TDX module is ready for KVM to use.
> > - const struct tdsysinfo_struct *tdx_get_sysinfo(void);
> >   Return the system wide information about the TDX module.  NULL if the TDX
> >   isn't initialized.
> > - u32 tdx_get_global_keyid(void);
> >   Return global key id that is used for the TDX module itself.
> > - int tdx_keyid_alloc(void);
> >   Allocate HKID for guest TD.
> > - void tdx_keyid_free(int keyid);
> >   Free HKID for guest TD.
> 
> tdx_enable() is introduced by TDX host patch series and used in patch 5, should
> it be added to this list too?

Thanks, I've updated the cover letter to catch up the host tdx patch series v10.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

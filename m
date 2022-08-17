Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97748597844
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 22:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbiHQUxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 16:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiHQUxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 16:53:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0059B753B5
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 13:53:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a8so13524591pjg.5
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 13:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=copKnaXkpj/PrdXoSUh50plMYt2cxJb8zNQUI1sfapA=;
        b=dCyKrDnHffHMPE6zwy+Q7dZ4Ubotg1BDm/dOjNXU/xI1BiYUerO9CRhZwdkqtfaDm7
         XuOuyklex7q/EQ97Mr53rpTjNcyZaxALRxHbZcvyVcZJyeUILr2vBugIjYSrPAcrQ3o1
         6d97ejy4FAbxM5nlOxJ8ps6SvtF6vhR9EOXwpY3XG84CHpL+XhWhu8InRN4uq21dG3K8
         X+sMP2EcHvZmKNr9B+RdIlOLpqnfoF7HH6WfoFJU3ObgkKBLPYng7+/Uh9qAtDk4MBzo
         1NOo+3PS4V1QvalfN62tSNBgtWn3rvXRcZ22j/f9IGuH/Q09QcCFQBDZKkhlsx6fKPCt
         lkoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=copKnaXkpj/PrdXoSUh50plMYt2cxJb8zNQUI1sfapA=;
        b=zx4ku/zpZSepfxCfppZ2Cck2CQAhFp4VuQuEVuvP6k9e3rIKxaT7FqaAaoCaY63HNP
         gSfAO48LSZNOkMbEB6d64VfPXukxTokDT5h8Ug1rqKLfDFHZN4CQwUFR4De7DB9GZrti
         SJ2cIx18AJMKvQXYS2uMRHe1s2cdAZVYnUZ5ppw7E63Njo3rSttNiKTy3raVgLK//yJh
         VwLYRzQJ82o94Jb0p7Qi4kob0651Lc/po+jz9Nx4yImS8fCJJ2yPFjmES6FP4kxoso/r
         BhfvOqvwB7lSRArg1sF2unTHfvJPkYTBorBLZwp990RUsqXMklSK5iJXuCCxQCULxg9l
         Y58A==
X-Gm-Message-State: ACgBeo18xnLYBTjOrQ1YxrDVm7rOmZGTIRd5lDXWz4SrtxyEaDldoPo8
        3i+ooN0m2F6rGQ6kK+ESW7PA7Q==
X-Google-Smtp-Source: AA6agR7DXTKxmlIOqf0As2iSnVOles3hsHy0jPA3gsCK/wFyUdb62hdy8Gjnx++fqfYpJi/mCskauw==
X-Received: by 2002:a17:90a:ab8d:b0:1fa:af75:e4ed with SMTP id n13-20020a17090aab8d00b001faaf75e4edmr5600179pjq.119.1660769619374;
        Wed, 17 Aug 2022 13:53:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b10-20020a170903228a00b0016be596c8afsm322533plh.282.2022.08.17.13.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:53:38 -0700 (PDT)
Date:   Wed, 17 Aug 2022 20:53:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+8d24abd02cd4eb911bbd@syzkaller.appspotmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in kvm_dev_ioctl
Message-ID: <Yv1VT2SPrfTQhlrV@google.com>
References: <bb50f7ae-0670-fe7d-c7d7-10036aba13f4@redhat.com>
 <000000000000b4d88605e675a71c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b4d88605e675a71c@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022, syzbot wrote:
> > On 8/17/22 16:30, syzbot wrote:
> > #syz dup: BUG: unable to handle kernel paging request in 
> 
> can't find the dup bug

Heh, it's always some mundane detail.

#syz dup: BUG: unable to handle kernel paging request in kvm_arch_hardware_enable

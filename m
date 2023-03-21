Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496C16C2664
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 01:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjCUAjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 20:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCUAi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 20:38:58 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6281ADF5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 17:38:56 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id z18so7654849pgj.13
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 17:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679359135;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fLfNMIdfmWa7uxic4s3XFQUgdy9GXPiHgpuDGt8m5xw=;
        b=hlX+WuWF7iamBEHMLyEdDQrY1f8O96E9dvQT8w3R57CdTQ0u12saWrnuYqx2CDoJou
         dnUUgEIgNqx3L6YkufrRp2vopty/zRsucsVaA9ef7rP0PPRWkGxs37nBZ5se8b2Gh6bm
         Kb41wkj5f88nWFRb/0hO8WRGoHnLA+ZSp91p6qbujiljmucqgDwTMJ51sQCkSk64/pkn
         DxJcH/Kctvn4j3q7Ssmy9bFSyeDZYmfj5R6sjrNS4DDvWuvNR27vOlnOS4ol9YsyQkVc
         nAsow+J3/lwjWKYvyklhL+1aegOdz7P1lxysA5vHUHFM4NFHOxpvE/9y5+ewNNCxUpoW
         mKfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679359135;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fLfNMIdfmWa7uxic4s3XFQUgdy9GXPiHgpuDGt8m5xw=;
        b=sHDcPNy+SKlCXGaKiih8mEMHKvhWceOyVwG7n18Zxxi/SB0pwiUdUv2ippQbYQE5SD
         Rbd8yqLxtYYe4JiZPcnTe/51o6/2eNbFvJywaGUstogLBXv4Ugz6GQKpHVbJJig9qwES
         u+PNikqMbACGNN3o9EeCBrxLni7y6uEOI9fHxXgvxWNn0x/ZT7PQnbs3vLLxiHsp+No8
         AKMRYDUZl4PeTBFThIvxdCRYBJHUv3HbUtVnIJ4yxHQvLHwarTBQfMZmo8Tq3kjd7YIU
         nvsXyKcymX4ifcuudJX1Tm8hwNl+VXyANHL84lPtXQXabYmImfNWc50li/K8lQxLxrmx
         6o2g==
X-Gm-Message-State: AO0yUKW+wzz3jrjAqZBz79AYZqCfDoHzH0P5vNKB/2eiiqcKEHbelmZr
        734UAU4Bl6iM5G9hxt1IPhw=
X-Google-Smtp-Source: AK7set/NLIOTg6o36oQto++fvyXfjMMmrz/WAktHFWcJd1CpavWF+Ld/7hpo/VPy0VYbXkzossulPA==
X-Received: by 2002:a05:6a00:4e:b0:626:2199:7bca with SMTP id i14-20020a056a00004e00b0062621997bcamr624238pfk.31.1679359135524;
        Mon, 20 Mar 2023 17:38:55 -0700 (PDT)
Received: from localhost (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id c27-20020a634e1b000000b0050be57d7ec0sm6558964pgb.67.2023.03.20.17.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 17:38:54 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 21 Mar 2023 10:38:49 +1000
Message-Id: <CRBN4LSJ14G2.6N0CI165ZTJN@bobo>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>,
        "Thomas Huth" <thuth@redhat.com>
Subject: Re: [kvm-unit-tests v2 09/10] powerpc: Support powernv machine with
 QEMU TCG
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        <kvm@vger.kernel.org>
X-Mailer: aerc 0.13.0
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-10-npiggin@gmail.com>
 <62fc117d-45a2-9aea-1a2f-973181395430@kaod.org>
In-Reply-To: <62fc117d-45a2-9aea-1a2f-973181395430@kaod.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Mar 20, 2023 at 7:47 PM AEST, C=C3=A9dric Le Goater wrote:
> Hello Nick,
>
> On 3/20/23 08:03, Nicholas Piggin wrote:
> > This is a basic first pass at powernv support using OPAL (skiboot)
> > firmware.
> >=20
> > The ACCEL is a bit clunky, now defaulting to tcg for powernv machine.
> > It also does not yet run in the run_tests.sh batch process, more work
> > is needed to exclude certain tests (e.g., rtas) and adjust parameters
> > (e.g., increase memory size) to allow powernv to work. For now it
> > can run single test cases.
>
> Why do you need to load OPAL ? for the shutdown ? because the UART ops
> could be done directly using MMIOs on the LPC IO space.

Don't really need it but I thought it would be easier to begin with, and
then I thought actually it's nice to have this kind of test harness for
skiboot as well. So I would hope to keep the skiboot bios option even if
a no-bios version was done.

[...]

> >   void io_init(void)
> >   {
> > -	rtas_init();
> > +	if (machine_is_powernv())
> > +		opal_init();
> > +	else
> > +		rtas_init();
> >   }

[...]

> > @@ -195,6 +197,8 @@ void setup(const void *fdt)
> >   		freemem +=3D initrd_size;
> >   	}
> >  =20
> > +	opal_init();
> > +
>
> This opal_init() call seems redundant with io_init().

Oh you're right good catch, that might be an old piece before I cleaned
it up. I'll have to fix that and re-test it.

Thanks,
Nick

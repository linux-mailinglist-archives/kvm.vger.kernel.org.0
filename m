Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626A34ADBF2
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378755AbiBHPFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378777AbiBHPFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:05:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89693C0613C9
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 07:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644332708;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=vKPPCFRmmcIf6NWOhQcqEjdqZT2VEGESWhQmL1Cfmks=;
        b=crSC0DeLy+gpSzVd/VgUH69fIpx8BkcSvuqETPS4rqIeKLkSmn0AlHtRvwEsXMEoV/m81Y
        zxrvYM7SW9SUUz4xzdB8ohDsdnTwwnJjPluP77jggfd0/023f+D0fp8lKeVK8pNsYjy0Hz
        V984+WmcpZ1viCLDpFl+uqUEMqEMsC4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-PF7dGJFYMWm7CQNJxsl-Ag-1; Tue, 08 Feb 2022 10:05:07 -0500
X-MC-Unique: PF7dGJFYMWm7CQNJxsl-Ag-1
Received: by mail-wr1-f69.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so3541070wrg.19
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 07:05:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=vKPPCFRmmcIf6NWOhQcqEjdqZT2VEGESWhQmL1Cfmks=;
        b=NukhvrJJmfYC+HkeHXqLZttyWeTMSyD3sJlArjmcEDeuMffNliXxHamSLKk/bd2V8H
         TPSFhYbSRmDcVZm0/ZALThKSFQFrFfHmttHKMv7gtHf8eKecMY6N1gdq3/9i3myGOQxF
         +sreMbhD/HlqUeAJaN9yoEznKG12Tw0h+wq2muSohYbauK154Ch+I9QdrJ1JDWOa3bMr
         h38fFiF8xZETlnQNyPoKwc2qB9ExOVHmZDFX7M9bJpnVjBEjzR40aYprfHTysojtj/mH
         LBtzQ+YA1wr5LiI2m0J4eoXKnubqAULYRAfNlHGsIBhmfDHwgTdQ/8kt8KZ/Yf1UyRpu
         ZH1Q==
X-Gm-Message-State: AOAM5322K/KsCqYZHqbZyWyBkY5kiEwLvkb5JOGc/1L5zur2E3aYm+0B
        qFd/8veIcl3Fed/JtzpXKrteithzzgLuj9cAbiDWfxJNEEjnX6Kj4vMretGDIHsoXQcraiNerIc
        6YQ4615IIS4FEylHHWYTOk8FO1hV4g6O1wZuupA+nRwY4DxSC3OnyjEstSXv9W/nc
X-Received: by 2002:adf:ee46:: with SMTP id w6mr3771907wro.451.1644332705581;
        Tue, 08 Feb 2022 07:05:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeXGFqT/OAm+pEcv7Ihk1SCLekWypHtrByqRNPYLdX+s27Nc67BWakMrixmd8U6atIVjjzow==
X-Received: by 2002:adf:ee46:: with SMTP id w6mr3771880wro.451.1644332705305;
        Tue, 08 Feb 2022 07:05:05 -0800 (PST)
Received: from localhost ([94.248.65.38])
        by smtp.gmail.com with ESMTPSA id z17sm2396671wml.38.2022.02.08.07.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 07:05:04 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call minutes for 2022-02-08
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 08 Feb 2022 16:05:03 +0100
Message-ID: <87fsot761s.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Minutes for 2022-02-08
----------------------

- Greensocs have patches to convert it as a library
  Are upstream intersted?

  Phillipe has some patches to allow to load architectures at runtime,
  so he only has one binary.

- Greensocs is finishing the patches to do the configuration
  They are rebasing

- Changes to startup to allow QMP to start sooner

  * Create a new binary to experiment
    Once something is done, we can decide what to do
  * Make QMP available the sooner possible
  * Copying the current one and remove stuff also takes too long
  * Markus started and posted an RFC
  * He asks to create a new binary
  * What should the new binary done
  * Idea is that we will do the minimal possible thing on the new
    binary, have it on parallel with current one, and we will decide
    later to/if remove the current one.

- Paolo will post patches that just create a binary than setup a qmp
  socket

- Markus will rebase its RFC on top of that

- Greensocks will post his series to convert QEMU into one library

- PhilMD will post his RFC to enable a single binary for all
  architectures


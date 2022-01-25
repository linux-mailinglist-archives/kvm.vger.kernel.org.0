Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1357349B92F
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585111AbiAYQow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:44:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1584470AbiAYQjU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 11:39:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643128759;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=gCTkVpuQFuTN+ZEnNE/wRhp4KZsQR2gL5dpMvrxlEss=;
        b=a1b2xhAFe5Hen4FT0t9iVJXKCeQl7RTT3iXzT2Ut0BmnilpC4FJFye27RGD6nirl43Ikfy
        9f5t3TNa6wFOQ7YCvPZMm0FtUOj28+Z6mBy8NI4RIeID37rxWo+S0UrQ39JugbFVnXEUpD
        Pv0U1wZ3aw0U1xy8cb+/OnOd1iLAiF8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-Bh43Y7yxNXyz3KFTDebwsA-1; Tue, 25 Jan 2022 11:39:18 -0500
X-MC-Unique: Bh43Y7yxNXyz3KFTDebwsA-1
Received: by mail-wr1-f70.google.com with SMTP id c10-20020adfa30a000000b001d79c73b64bso3307799wrb.1
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:39:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=gCTkVpuQFuTN+ZEnNE/wRhp4KZsQR2gL5dpMvrxlEss=;
        b=682OYHLEd3Q4gHTrA0tEZxkGNlbHrdeirwXOnf/nUGYCn35MoyKWXk78iRBQot7axL
         AfB8oJEZAiWfoPVfqZ4L3CsaVfdCO2SH0/GAEG4R2vIdDOaDvu3iUIVc6bfasxi9UnjN
         jJMMaMFC6SnOoTM0cfL9hQNOPSFCwQ+a5TOpzC//KgAuLoKazfkFClPKMhK230GYMNvg
         wgnEbF4ErEexBDd/8mqRYU99uatJPCnl5P4AgGc1fvsGICo75hcxU7KVeZ2pxgM/FdLg
         KwZTyIK7AyG1RtAeEmvUS35XYnXa21d3/xNovFRAdedgw+DeYHg71WbDaXCGI8AXacLM
         mtiA==
X-Gm-Message-State: AOAM531kwxtPvmyec+U9ts7ER1ZHHW93HRZqtHqAunbIykAdOPxa3Nol
        bJmapUE5oaQt9izXCdY/EQXow6mB4tw8CSyQswoL6Jb2hOKIZFIIgBpNEoc0xD/6T2GpocuCQWa
        TZzowSqH346XDxsMFYsRnbAY/qfKInKGbakpwxZBxsEtrNXVSe/NNrGffMB3WIJga
X-Received: by 2002:a5d:4906:: with SMTP id x6mr18728471wrq.552.1643128756962;
        Tue, 25 Jan 2022 08:39:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6XudU18Mwwyo3m4U555YS6s5SlrTdntmk/UyjkROZJrtMI1DbQ3f6vv9GW8yDMGHK9K0vCg==
X-Received: by 2002:a5d:4906:: with SMTP id x6mr18728455wrq.552.1643128756735;
        Tue, 25 Jan 2022 08:39:16 -0800 (PST)
Received: from localhost ([47.61.17.76])
        by smtp.gmail.com with ESMTPSA id p15sm17089157wrq.66.2022.01.25.08.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 08:39:16 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call minutes for 2022-01-25
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 25 Jan 2022 17:39:15 +0100
Message-ID: <87k0enrcr0.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

Today we have the KVM devel call.  We discussed how to create machines
from QMP without needing to recompile QEMU.


Three different problems:
- startup QMP (*)
  not discussed today
- one binary or two
  not discussed today
- being able to create machines dynamically.
  everybody agrees that we want this. Problem is how.
- current greensocs approach
- interested for all architectures, they need a couple of them

what greensocs have:
- python program that is able to read a blob that have a device tree from the blob
- basically the machine type is empty and is configured from there
- 100 machines around 400 devices models
- Need to do the configuration before the machine construction happens
- different hotplug/coldplug
- How to describe devices that have multiple connections

As the discussion is quite complicated, here is the recording of it.

Later, Juan.


https://redhat.bluejeans.com/m/TFyaUsLqt3T/?share=True

*: We will talk about this on the next call


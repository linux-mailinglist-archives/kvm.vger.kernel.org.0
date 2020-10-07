Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F56286299
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 17:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgJGPvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 11:51:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727005AbgJGPvC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 11:51:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602085861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2LDTTdCPWTiwrRY0aS5TNe4GyBD13gMBivlh1zs5XQs=;
        b=Srl0LCzJ55+sYsc8o6Do72ZItELGQcV7l8UI3/vJ/iAIJrWvXMkPEHFiJhKWAmejLav0Jh
        F9f7IM2vCms/Ash0FQ0w2Yz7HExQx2atBmb+Sx0EkXQEi3oE3+tok7Pqqrf1FQjJopDYSs
        yayOtt96DMivnfjbyVUbuOr17GSjZdU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-JHV7TcetP7i8vqz5a6tzJg-1; Wed, 07 Oct 2020 11:51:00 -0400
X-MC-Unique: JHV7TcetP7i8vqz5a6tzJg-1
Received: by mail-wm1-f71.google.com with SMTP id p17so901495wmi.7
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 08:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2LDTTdCPWTiwrRY0aS5TNe4GyBD13gMBivlh1zs5XQs=;
        b=i8wftF5JUFy9y/FHHgBbe6xHY9gQAu1iUPvN/Eedy03/2pJvzI5ser5YLutCcXHMyO
         y2bjIfLQsfHqMQmOKmqr9f6PeHJyl4ZN1RYnSGknngURg1Y5xp83G/t8xMl4xtxtgKSM
         ungwUVnZ8ln4ds7vXeR57xflPztAb/a8l0H5JHfCpfDFjyL4dnHkc92cT9hHpYdeePah
         5jAeBKD+QzYqpfn4o7t2TdMQyOQPx+nUYbhVfzcyl9WmDIOb7ygDmotTNg4+3+tcOoC8
         9RpZq+vlYLlgSzfwgvPT2UAjDKwb0VHvLpRQXmi//gvTqb5Ojyzec6+ADmDtDu6IDg1H
         3aug==
X-Gm-Message-State: AOAM531NMtqouRLvAnNbiZ44gY0yiFySMTX6JSULvCseDC3T/gJ8C49Y
        f/mXjmzP9aujHoM9SUscII7xgIF/ty9BqNRvw5dsIWKqqyZzBbj3G+0vbABqzwm462A3uBfxkyp
        Bf3QuOPy/EPep
X-Received: by 2002:a1c:e154:: with SMTP id y81mr4119924wmg.111.1602085854765;
        Wed, 07 Oct 2020 08:50:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNNT/QJVwnm0xfGxbmmHDDQjvUuWtYHM/NyvbPFlV1vOpc8TTvuf2PMEmrrZBgMxnQYNhihQ==
X-Received: by 2002:a1c:e154:: with SMTP id y81mr4119908wmg.111.1602085854582;
        Wed, 07 Oct 2020 08:50:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e15sm3000361wro.13.2020.10.07.08.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 08:50:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     BARBALACE Antonio <antonio.barbalace@ed.ac.uk>
Cc:     "will\@kernel.org" <will@kernel.org>,
        "julien.thierry.kdev\@gmail.com" <julien.thierry.kdev@gmail.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: kvmtool: vhost MQ support
In-Reply-To: <AM7PR05MB7076C2EED57761B346BCB17FCC0A0@AM7PR05MB7076.eurprd05.prod.outlook.com>
References: <AM7PR05MB7076F55498C85087F09421F6CC0C0@AM7PR05MB7076.eurprd05.prod.outlook.com> <87a6wz8t27.fsf@vitty.brq.redhat.com> <AM7PR05MB7076C2EED57761B346BCB17FCC0A0@AM7PR05MB7076.eurprd05.prod.outlook.com>
Date:   Wed, 07 Oct 2020 17:50:52 +0200
Message-ID: <87sgaq6nmr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

BARBALACE Antonio <antonio.barbalace@ed.ac.uk> writes:

> Hi Vitaly,
>  Thanks for your quick feedback, sorry for the several formatting issues! I applied all your comments to the attached patch.
>  For the moment, I would prefer to keep 'vhost_fd', but happy to
>  remove it if you would like me to do so -- just let me know.

Hi Antonio,

in case you're doing some changes to the patch you're supposed to send
'PATCH v2' to the list. Also, it would be better if you mail it with
e.g. 'git send-email' and not as an attachment so it's easier for people
to review it.

(I'm not a kvmtool maintainer, these are just generic rules for kernel
patch processing)

-- 
Vitaly


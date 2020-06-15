Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC7A1F9499
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 12:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgFOK2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 06:28:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51087 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729348AbgFOK2g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 06:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592216893;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zEwHOEUVIsuITaUIIISThUPaugqQZ5HRCgo6EY/fF24=;
        b=A3DCyxSCl0TT4ax67W1Nq71pfR/BCeW9SZ0C9+evZsonNRvZ3drs21rIy0/k1kYclLKul6
        ZF8FOyV+Y3yjYI1drkghafzKOyl0yfjA51HmGj9hx0/j4dzBoatizWaWugTo6xFt9MYJ1T
        NHeT4dQTOjsNZ/1RUGuZP7icvjSvmG4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-kdsTMPT-M7CtvAaMxFD4uw-1; Mon, 15 Jun 2020 06:28:11 -0400
X-MC-Unique: kdsTMPT-M7CtvAaMxFD4uw-1
Received: by mail-wr1-f72.google.com with SMTP id d6so6862112wrn.1
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 03:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zEwHOEUVIsuITaUIIISThUPaugqQZ5HRCgo6EY/fF24=;
        b=J87yTVizL55MZ1Vywe0i6v0C5zYRE0xBGD1ZB0onBSHN3zVykZ3ghLHe/LY8SKbeOE
         5kgeTddMA1tKyMRshCfLWizJ8F9l0d+mzn0RRS25EG/4HnJpwg7mJTCnkf3EJJt3rnkp
         zQgmyxnpU4YZmLptJC1trK/C5J1YBVc3F6ROJC1kAZRU2hlFHJ6dGLo4a18ga7y1ysnT
         ebBOiLlgkEZts3lSaLNfY7rXYFNJsazA1nDW27u7K0CBdsNhEQUaQTNzLt5HhqhteljE
         PEzZBG6LHyof1FqsJLCee1G9oy37ZdXM1caJlJAWdb0jsAS/t9qKyEV53Nb2nAmxPKcl
         wD+Q==
X-Gm-Message-State: AOAM533e/3rESM5Z7cm7oWjybZbkAxjn0jSpxV2ud7NZ6hOcdwLNzTux
        GPdLhZniQJYcER4tekd67Ok6Ny8gbhSIFClSWSMhYKvURE3uRHUtKJVEiGUAhpcEai5l1dykjvF
        twpSVQoluuPex
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr12057846wme.14.1592216890147;
        Mon, 15 Jun 2020 03:28:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXZaVM8mnYQPDv9oJ62jKk46AqV6gjiZeFq/If6XKT6ORJLONLwMgXxzSqq2qzwKUh4cH5zA==
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr12057822wme.14.1592216889906;
        Mon, 15 Jun 2020 03:28:09 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id r12sm25091486wrc.22.2020.06.15.03.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 03:28:09 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: KVM call for 2016-06-16
In-Reply-To: <6324140e-8cc1-074d-8c02-ccce2f48a094@redhat.com> ("Philippe
        =?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Mon, 15 Jun 2020 11:45:17
 +0200")
References: <87wo48n047.fsf@secure.mitica>
        <6324140e-8cc1-074d-8c02-ccce2f48a094@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 15 Jun 2020 12:28:08 +0200
Message-ID: <87sgewmxmv.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:
> Hi Juan,
>
> On 6/15/20 11:34 AM, Juan Quintela wrote:
>>=20
>> Hi
>>=20
>> Please, send any topic that you are interested in covering.
>> There is already a topic from last call:
>
> This topic was already discussed in the last call :)

Sorry.

My understanding from last call was that we wanted to discuss it with
more people from more organizations.

Later, Juan.


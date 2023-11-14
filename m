Return-Path: <kvm+bounces-1650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2E47EB13A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4E071F24C3B
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 13:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A0A405E3;
	Tue, 14 Nov 2023 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JGgqwsRB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63910405C0
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 13:52:18 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314C71B5
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 05:52:17 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-507975d34e8so8089257e87.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 05:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699969935; x=1700574735; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1rHiX2Qvn2r7/an8n6Ja5nYc1kV9MxTSnN/kj3LwH+Y=;
        b=JGgqwsRBuFrOHfykHYdQILt/JauQcyUH9VoLgi+OtnUVSwuouNZSpX+AjjTfK/PShC
         H/uT3c+A4XG9D95z9kXK8adwsk9dbhTebHzFEo7zCFyIwYyUG/rby64TMZbF15HQQaUD
         TUu4zxNDP3o/3C7sqaZA4Hf1VccR9Kwc35DFxNAiyFkP+6thi9tVLUKaY2oQI7bfNyYb
         2MroXAA3TTw+QHLVT+3MlqOWAbsujV1lmYNcuY4yyqy5kJqmZbjXINjABmPVOo6lOS4F
         q0r5gkz+k0nbh1p2zvCSPNBnxy/ImE4yq8qJTkrcNegUG5P43zRg6pOvXTKD6Qf0kNhI
         avNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699969935; x=1700574735;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1rHiX2Qvn2r7/an8n6Ja5nYc1kV9MxTSnN/kj3LwH+Y=;
        b=ixp2QnOjz6c5hMo6XkGeAqd8UJ+prRw492SrQ8idutyKd1rcmmHWinap2VydKmsmVO
         RgmcIomDJCgvFzLVWu6DHsetm0c8/q0dsXTp/99FEcNJ7D91iF+abVONFBgCkjwq/Ww5
         nZ9Id+t5gGZWRh1Y7om9MHTPYiuvon5h5Hg6FbnUAKlU3lzezlonLhhfB4IPoSS+pKoc
         3ucMwQTgkueoH1GjKvtr3UCLCkhZhT9dkVFmZD1j58dTXUnyJT/eMoIYwthreoOtheVA
         GfKXtfPysU390kMvmXkBgYd6fZvwap5DL/+m3VbKP0u8Na3o2p40dvIkl3SGzykfh56H
         NklQ==
X-Gm-Message-State: AOJu0YyDKvFVGYJhxqMEHKr9mz81l6Qrhi8oywIf5ZS55at9ljAYl76d
	tf0zSiEbnzNj9IX3vRj1OmxMH4jVLx5HoB9lV58YSHvg
X-Google-Smtp-Source: AGHT+IEgI9NUmSom9z+B5ZFQ5mckKNvtR6ctToCQAvJA1c1BdvA7mAnwtYgztxgRWB5c7WqFGk9FnWvl78Erqwpq58Y=
X-Received: by 2002:a05:6512:b92:b0:507:9803:ff8b with SMTP id
 b18-20020a0565120b9200b005079803ff8bmr9238783lfv.44.1699969935078; Tue, 14
 Nov 2023 05:52:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Y.G Kumar" <ygkumar17@gmail.com>
Date: Tue, 14 Nov 2023 19:22:02 +0530
Message-ID: <CAD4ZjH3z5MDUA9A_7-nqJry7riJ9Un-e37avyFsrcwwJ=uW+QQ@mail.gmail.com>
Subject: Need information
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi All,

Is there a way to collect cpu steal time metrics of a kvm-qemu virtual
machine from the hypervisor on which the vm is running ? Please give
me some opinions ..

Thanks
Y.G


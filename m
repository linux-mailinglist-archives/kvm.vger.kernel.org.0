Return-Path: <kvm+bounces-19654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F6C9083F4
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 08:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 033641C222E8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 06:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38731487E9;
	Fri, 14 Jun 2024 06:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="CsA+U6BJ"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372D913664A;
	Fri, 14 Jun 2024 06:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718347571; cv=none; b=OyM/r0yQTN7GqSOemiVhoqt2SOACxbtG2C9ksCtyog3LlExHJ8a+OJa93GA1yFOEvIqocFVumel4B31vewlQIR9EgzHekSPc3vAhIu8B2rtfKNVCPK/TZtKOj2UJM9iCjs4LuG7e42cAv4hJPFFWTCCVdf42voepuTP0veRmC2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718347571; c=relaxed/simple;
	bh=YH7LKrwSFCa+CoKU0LWv/vYqquj8BHHJLekmHbOSkzk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ha8cBCAdEURAldWdOksNcLUpN/QhEzaz0wkvJGVs4g9yXNJdi4ZeCPxwLuGkMOn6MclYes/F7UD4u7IJu2fIRDufqBfZj0kWLcIeXg4PL8njLyJVHK/lXP40R9BXYvsEnG17zTuR2Rh6gFmC3eg7dgGJealCMRMiALTMvhslRZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=CsA+U6BJ; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1718347552; x=1718952352; i=markus.elfring@web.de;
	bh=5zlFpg3ORlkfLRd5irYj/EAogjoqsKYjaMjqGShyL7Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CsA+U6BJOimHdtLSvECgevR/IcYLGzd3Ds5NdwM1xn0odtTgkhkTNq4IANoztDLd
	 mEvBaz2AZgbS7yFh+e8+q2pCs0yC2jLEh7n2u8A5gBcDZHF2Ow5hp8YGWb1+rtui8
	 4PlZSyavq2cjEI5UflWckVrQcX7U/GesNM6xdy8q88fYacB8ZhklC0KnvOaSoSu7O
	 Ls3x8ZEWhuZ96B81LNGOnla7QPoqn1gv69ISQDJBdYYD8zgpEzrsySe6tmB/1Ha4H
	 IM5jfLfT2JVt3AR011C/2VzSFmqxOdLd7pj19H3ecHvlEEAJFJw/XUHMksz+N97Jv
	 WwSDJfTcUbYR34kmsg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.83.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M1JAm-1sFGbi1CvK-00Du3P; Fri, 14
 Jun 2024 08:45:52 +0200
Message-ID: <93ec485a-8620-4f24-80b2-0e08107c6287@web.de>
Date: Fri, 14 Jun 2024 08:45:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Dan Carpenter <dan.carpenter@linaro.org>, kvm@vger.kernel.org,
 Yi Wang <foxywang@tencent.com>
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 =?UTF-8?Q?Christian_Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
References: <02051e0a-09d8-49a2-917f-7c2f278a1ba1@moroto.mountain>
Subject: Re: [PATCH] KVM: fix an error code in kvm_create_vm()
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <02051e0a-09d8-49a2-917f-7c2f278a1ba1@moroto.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kse9iwq86q4OapouTZFjQRTEBswgWxJ0dRt+ZHSdFA2UOHOq3Ew
 OwT1xgCN0hZnc3qUpN3/1Q1UixgusEBeeTOjXt/Jb9guplTH65wgSCPSrxxU+2/LrZi1QZ2
 wA5DOJXH6360dLOVNmJB/CPMbQEjs19xApq2zy10lFWXLixfwGEIteY/12Vzc25fZhkyGyx
 4APKh+JKW3jcpjQ3d/5Ag==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UAoW34K0xjM=;2HaTklojmuEO1RhTtNKZoOu7tjY
 h68lhrk/rGShI+dRDf0yHUwheQ6BTOIH6enIara9fNKlgPo6bM6wwPSCPSneZIrRb+i8xVdKF
 62vr+fYt/ftcv78pI2bxXXM4Jp1e/kqeBYWO63Aju7W5wz/RRvXyzc30rA21ck788IRSzLvvV
 p/DDbM09MBYVhLGeutpqL38IYf8e+hg+cJd2XaB+cXFKBmzNCiKSJSqTXi2RTg4FfqUxLXELW
 4n4jbjwkV+Kmg6jBHjh8CLfOPPKRIqs85fkliSpAkni+VS3iOJcSiTazVqJMvqBHZ0D2QpgWM
 J3NPLHqlpqmBO3us68/bvDKbLpDTpvpK9sJWB0Ix26fh0fTt0IgX0yDi4CSfwF2otoeOqX2/A
 NDVAkOO7h9H1t1tYoV6Q9TwVwjjQ7NERtlghVyRC7H3jRpREES0/U3gxBE/iYOXzaHGiIW772
 M839wQqx2bgupubVcXhoD4v2kN1Tn7/pHgmq+3JlXbbnis0zNqxn7oHBg/Demeh7KBwLf3rqe
 dL0Kf53NHBWYYziMpvgXThWJzQxAWtLMVD7zcImI4ALNYqp6jvaz8EdnJDDHEWjv7GO3vcu04
 InTJUctO91cnc99Zkfk7t/QarRPB4aKKTh5s+RwPScc81P1I5o1FxCX+XjhYQ908mgaJD3i0g
 ABYdxAgVmZH/fFcSRcI4YwRr2xpnXjwiVN/Vr6T6p9mS0y009wNTyqzs4lSPBEk7nHCrs/fKZ
 aCSPk+MNFsHudL4BgphN6QQpEAuUlgoNDWb8pWN4hjiAPV7qIidi4TGhUw+dUt/djOvRxJ31x
 OHMOpqpJJ72qquMo9eiHKOOiAeE0UBJD5sSNcy7gpdcVs=

> This error path used to return -ENOMEM from the where r is initialized
=E2=80=A6
                                                  place where the local va=
riable =E2=80=9Cr=E2=80=9D =E2=80=A6?

Regards,
Markus


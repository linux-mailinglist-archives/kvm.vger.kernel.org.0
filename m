Return-Path: <kvm+bounces-41060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED60A612D6
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 743357AE770
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 13:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E68EA1FFC7A;
	Fri, 14 Mar 2025 13:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="H3ia/hIF";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=anthony.perard@vates.tech header.b="xXviNbD/"
X-Original-To: kvm@vger.kernel.org
Received: from mail177-1.suw61.mandrillapp.com (mail177-1.suw61.mandrillapp.com [198.2.177.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF21FFC43
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.177.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741959304; cv=none; b=RnENPPEmqay64sHp3m88xWtx8eBj6owN+SMo/ZkeWzzAjS4Koehx8jPgYywkq6IKpUvxWI/8XtueX+8vi8Ox4Jo/XsVvqDW3gdsKWrjbQW2+/39Rqp9AKaznIcIV6DUzBiUlNjtbV8u8Ap3nT2j5fcwp+y/MqZzrJ0oXjRa8VBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741959304; c=relaxed/simple;
	bh=7GbmtLroPdOLeL7Hde3KJhDExoaO1SitOpm9AV+s6hw=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Date:
	 MIME-Version:Content-Type; b=SHy6FIK0zyWV6CFzDi2PEj++NY56MtDh9oX3HOk/hgKU+FS7veR3IMDQJTck4MAwcwjUl7xMFkz7kv+KBuagUvtc2vVsFsM5FUit7naGm75Sk7JSqHwdW04em+qRvH9jfmcW9EHSvKmLJDLWm4lqdX/oN4yCbqpWSzXrF0tp69I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=H3ia/hIF; dkim=pass (2048-bit key) header.d=vates.tech header.i=anthony.perard@vates.tech header.b=xXviNbD/; arc=none smtp.client-ip=198.2.177.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1741959301; x=1742229301;
	bh=uG1KcJgwcW9T2cGN3oyD/12pz8pEMNAmvmnymfhPGS4=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=H3ia/hIF/AvPIg2zvwqJJ/XG53RwDPeyxXpzzwqVB97t/cXZDqEczwu6aBV17xDcy
	 ZomkPHanrox4PXIm4b1nsQzoBZ+g7+A5amnJtuYgc+xPVFX1xAZcjGfJ6eoMnbKL+u
	 H8nuIfz2GLHCHi/7/S6BsMn6X/x1hUIoDSKYtXOEm0QU6r8tgvMvQMslpIasw5V+0g
	 mvJgB28UT/Omci0aus2UW5mynCwm1CZrnCpmksc+TP3gCGmFTlv3FMj3Kmgxw4E8JJ
	 QpeW3t2wPWP5RlUc3p8DyxvjGIhbKvnsjbcOC+yKaldFZT7wWvGypIHWGu5tKnw4EQ
	 p//D5o6V1ILJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1741959301; x=1742219801; i=anthony.perard@vates.tech;
	bh=uG1KcJgwcW9T2cGN3oyD/12pz8pEMNAmvmnymfhPGS4=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=xXviNbD/+I9vW+blP78O91Jq2Bu8xSZd60y1qpnpoWTl02j4F1eOuh6YUjeqakom4
	 AYOTPZp4gOtLKtyclf80bbw5maHHV7fSRruOtvhlPa+uD63TIcNmMqVWHzuiIVwT4l
	 LuS7LbhGJ9Glnf0ikqLTzpIlZfHbOsGPKMbne53NRIlKa5xEdV4+Ufzfz2CXPqt7yZ
	 O1eYERBfcZkrjhSCj5m3sRl+Nf6AnYU2/rX0CdwSBNml0AHCyMMkJ/v+agPRPNlVnK
	 A+KB53PJfKmj3tyQkM1yewApW9fD28OMfHK6wF9b6F9ztn6gz9SPN/pOTr55y+PIto
	 hTkgtPuETVL/Q==
Received: from pmta14.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail177-1.suw61.mandrillapp.com (Mailchimp) with ESMTP id 4ZDljK4L6QzBsTwYQ
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 13:35:01 +0000 (GMT)
From: "Anthony PERARD" <anthony.perard@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v4=2012/17]=20hw/xen:=20add=20stubs=20for=20various=20functions?=
Received: from [37.26.189.201] by mandrillapp.com id a73312c2cedc4c94ab96628d4e4f7041; Fri, 14 Mar 2025 13:35:01 +0000
X-Bm-Disclaimer: Yes
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1741959300664
To: "Pierrick Bouvier" <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, "Paul Durrant" <paul@xen.org>, "=?utf-8?Q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, "Harsh Prateek Bora" <harshpb@linux.ibm.com>, "Liu Zhiwei" <zhiwei_liu@linux.alibaba.com>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, xen-devel@lists.xenproject.org, "Peter Xu" <peterx@redhat.com>, alex.bennee@linaro.org, manos.pitsidianakis@linaro.org, "Stefano Stabellini" <sstabellini@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>, qemu-ppc@nongnu.org, "Richard Henderson" <richard.henderson@linaro.org>, kvm@vger.kernel.org, "David Hildenbrand" <david@redhat.com>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Weiwei Li" <liwei1518@gmail.com>, qemu-riscv@nongnu.org, "Alistair Francis" <alistair.francis@wdc.com>, "Yoshinori Sato" <ysato@users.sourceforge.jp>, "Daniel Henrique Barboza" <danielhb413@gmail.com>, "Nicholas Piggin" <npiggin@gmail.com>
Message-Id: <Z9Qwg4PC_1bEaOLK@l14>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org> <20250313163903.1738581-13-pierrick.bouvier@linaro.org>
In-Reply-To: <20250313163903.1738581-13-pierrick.bouvier@linaro.org>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.a73312c2cedc4c94ab96628d4e4f7041?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20250314:md
Date: Fri, 14 Mar 2025 13:35:01 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On Thu, Mar 13, 2025 at 09:38:58AM -0700, Pierrick Bouvier wrote:
> Those functions are used by system/physmem.c, and are called only if
> xen is enabled (which happens only if CONFIG_XEN is not set).

You mean, 's/is not set/is set/'?
> 
> So we can crash in case those are called.
> 
> Acked-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
> diff --git a/hw/xen/xen_stubs.c b/hw/xen/xen_stubs.c
> new file mode 100644
> index 00000000000..19cee84bbb4
> --- /dev/null
> +++ b/hw/xen/xen_stubs.c
> +
> +void xen_invalidate_map_cache(void)
> +{

Is this stub actually necessary? xen_invalidate_map_cache() doesn't
seems to be used outside of xen's code.

In anycase:
Acked-by: Anthony PERARD <anthony.perard@vates.tech>

Thanks,

-- 

Anthony Perard | Vates XCP-ng Developer

XCP-ng & Xen Orchestra - Vates solutions

web: https://vates.tech


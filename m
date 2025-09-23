Return-Path: <kvm+bounces-58602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D131B97E64
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 02:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DCFF4C07CC
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 00:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D68217C21E;
	Wed, 24 Sep 2025 00:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=maguitec.com.mx header.i=@maguitec.com.mx header.b="az7SmRxA"
X-Original-To: kvm@vger.kernel.org
Received: from sender4-g3-154.zohomail360.com (sender4-g3-154.zohomail360.com [136.143.188.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DCA347C7
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 00:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758674064; cv=pass; b=pzqfYulPasRiWughijHXUQi0Wgju8dODENhoyydj8Aq4KGaQzDCbtsJklUBnjtYBSKg04hhYd/NImoYEIbZvpwEz5Bsetpymt+nzLEZUeLB5aYFp/YVKIFcP6HPYunuf0wS4usNPwzhxJ+CYdbrCobtQ9N3INVwsolilfSh/310=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758674064; c=relaxed/simple;
	bh=v5wq6KW7fkuW2C3G23/TSdeXhkFvhd3L4uxLHh6IOmQ=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=mRC6hgnq15pRdWcDMaj7IosZcSFrDvrXCm8dNtefvVRILC+nMqe5h6k5hib7GU1XO6awGqrwwFrD7TnglrYZx0BASiHcC6XKhW9kFB/QPQSpuwOMsSfMn5eX7KvQvk6MloaF9E8pYcULcyOg+SLE3QLzc7naZU6o2FRXVX4y8Ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=maguitec.com.mx; spf=pass smtp.mailfrom=bounce-zem.maguitec.com.mx; dkim=pass (1024-bit key) header.d=maguitec.com.mx header.i=@maguitec.com.mx header.b=az7SmRxA; arc=pass smtp.client-ip=136.143.188.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=maguitec.com.mx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce-zem.maguitec.com.mx
ARC-Seal: i=1; a=rsa-sha256; t=1758674062; cv=none; 
	d=us.zohomail360.com; s=zohoarc; 
	b=AkirL4qEqX9DmVSlh3q/ZTw+5sBe808wKA6qYpfi+p/FrHXtCMoB1/VZVBy5kkciQEQ06dCHz3YzvvqmtCqBhmy6R1SBngHzVyjVFIMdSwrxTJ2bi4vUl3MeZ62jp/2dh7TSn9PXkY+wuwNmZ2r+0VHOE89sub3zWk0WIdMEy9A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=us.zohomail360.com; s=zohoarc; 
	t=1758674062; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Reply-To:Reply-To:Subject:Subject:To:To:Message-Id:Cc; 
	bh=v5wq6KW7fkuW2C3G23/TSdeXhkFvhd3L4uxLHh6IOmQ=; 
	b=XRl+a73VlRVcGqjWhU7FZVA5wp+y1JvG555ZRBgAYjxPlwAciC8Mnx00/qoWpqMnGodjhdo1tr4KAeT3HIL2JpyhWC5jhEvci6aihZPEdtjRZyDYeCO94mnssc/97htIAULAF738WXw/WGge7O2UcjGCmiynjIqqOjEfrVt8mpI=
ARC-Authentication-Results: i=1; mx.us.zohomail360.com;
	dkim=pass  header.i=maguitec.com.mx;
	spf=pass  smtp.mailfrom=investorrelations+823c1961-98d8-11f0-ace3-525400721611_vt1@bounce-zem.maguitec.com.mx;
	dmarc=pass header.from=<investorrelations@maguitec.com.mx>
Received: by mx.zohomail.com with SMTPS id 1758671613454379.93290901300634;
	Tue, 23 Sep 2025 16:53:33 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; b=az7SmRxAdkCTRsBxjC4CRP9i8+ftS07iWaKOV5lmlwe2ckdHxZnb3PPYC1PaybZnSVoBTzzyrMYjo81A5nceFdsASkeNhbM4yBinsqs3rr6C+3h3aZMJw2/ToorVH1nlszIM017Uaxd+S0erF8kI7eBs9uvMfomcr1YRUQlVZx8=; c=relaxed/relaxed; s=15205840; d=maguitec.com.mx; v=1; bh=v5wq6KW7fkuW2C3G23/TSdeXhkFvhd3L4uxLHh6IOmQ=; h=date:from:reply-to:to:message-id:subject:mime-version:content-type:content-transfer-encoding:date:from:reply-to:to:message-id:subject;
Date: Tue, 23 Sep 2025 16:53:33 -0700 (PDT)
From: Al Sayyid Sultan <investorrelations@maguitec.com.mx>
Reply-To: investorrelations@alhaitham-investment.ae
To: kvm@vger.kernel.org
Message-ID: <2d6f.1aedd99b146bc1ac.m1.823c1961-98d8-11f0-ace3-525400721611.19978ff25f6@bounce-zem.maguitec.com.mx>
Subject: Thematic Funds Letter Of Intent
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
content-transfer-encoding-Orig: quoted-printable
content-type-Orig: text/plain;\r\n\tcharset="utf-8"
Original-Envelope-Id: 2d6f.1aedd99b146bc1ac.m1.823c1961-98d8-11f0-ace3-525400721611.19978ff25f6
X-JID: 2d6f.1aedd99b146bc1ac.s1.823c1961-98d8-11f0-ace3-525400721611.19978ff25f6
TM-MAIL-JID: 2d6f.1aedd99b146bc1ac.m1.823c1961-98d8-11f0-ace3-525400721611.19978ff25f6
X-App-Message-ID: 2d6f.1aedd99b146bc1ac.m1.823c1961-98d8-11f0-ace3-525400721611.19978ff25f6
X-Report-Abuse: <abuse+2d6f.1aedd99b146bc1ac.m1.823c1961-98d8-11f0-ace3-525400721611.19978ff25f6@zeptomail.com>
X-ZohoMailClient: External

To: kvm@vger.kernel.org
Date: 24-09-2025
Thematic Funds Letter Of Intent

It's a pleasure to connect with you

Having been referred to your investment by my team, we would be=20
honored to review your available investment projects for onward=20
referral to my principal investors who can allocate capital for=20
the financing of it.

kindly advise at your convenience

Best Regards,

Respectfully,
Al Sayyid Sultan Yarub Al Busaidi
Director


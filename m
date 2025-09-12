Return-Path: <kvm+bounces-57388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03451B5499F
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 12:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D443F3B41B2
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 10:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7854D2E6CBD;
	Fri, 12 Sep 2025 10:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ms29.hinet.net header.i=@ms29.hinet.net header.b="CLoXvNwE"
X-Original-To: kvm@vger.kernel.org
Received: from cdmsr1.hinet.net (210-65-1-144.hinet-ip.hinet.net [210.65.1.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC42C2D1
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 10:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.65.1.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757672533; cv=none; b=fb82F2oLLRpBs1mrqHhbKnzu81l/esM4zVbmRCq7ljEi4yWecGJR0+PI+tzaQKxr7/yA+VYTOKmrXMqmwgcnQw90Rt4oRUbkX+1ASryNR09NpfpKw0eWOYwMJ73+THY913dXjbbWjYVF4H+PKIE4RN66SqKWVw3KZB3o+bv56UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757672533; c=relaxed/simple;
	bh=r3c/2MLB5IPt4CM0E7V3LmBbj9Hu4p2iPuBKPoeHdVA=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=o8e/xjKbq9xwrV9qeGFdH8LosuyHxSyx9I6RVnbutNIRg8aSf6eh5qxlKJX22/0wG+pdgJ4gbtajwXJ58Zp0ifEJ+7AgNxQxXI7MZA9QUhPqH44HFP7WNCSSH3IBvLOKhp9BwzjL5ntBY498zXY3A6gWXuL0fZNwL3H0LnARNPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ms29.hinet.net; spf=pass smtp.mailfrom=ms29.hinet.net; dkim=pass (1024-bit key) header.d=ms29.hinet.net header.i=@ms29.hinet.net header.b=CLoXvNwE; arc=none smtp.client-ip=210.65.1.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ms29.hinet.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ms29.hinet.net
Received: from cmsr8.hinet.net ([10.199.216.87])
	by cdmsr1.hinet.net (8.15.2/8.15.2) with ESMTPS id 58CAM9vF861516
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 18:22:09 +0800
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=ms29.hinet.net;
	s=default; t=1757672529; bh=fZYi0g4z+oR1htNYwaFA3G7csXc=;
	h=From:To:Subject:Date;
	b=CLoXvNwEj1gsgAbEtWeOIZtBMT9jDANNUrSlVWIWZgftMBh634AFZtpX4xFyNe8KW
	 ZjAvjJaAUXxy/9apI/iZLbCeY4nJL02XikylDape990C0HkOZD0l9Q4l57lYy24XR/
	 DT5MI1NmusESB5XKcVJOp+2AGM5N88kMxWIcIgC0=
Received: from [127.0.0.1] (36-236-12-182.dynamic-ip.hinet.net [36.236.12.182])
	by cmsr8.hinet.net (8.15.2/8.15.2) with ESMTPS id 58CAFEo7364147
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 18:16:59 +0800
From: "Info - Albinayah 363" <Kvm@ms29.hinet.net>
To: kvm@vger.kernel.org
Reply-To: "Info - Albinayah." <europe-sales@albinayah-group.com>
Subject: =?UTF-8?B?TmV3IFNlcHRlbWJlciBPcmRlci4gMTc4MjggRnJpZGF5LCBTZXB0ZW1iZXIgMTIsIDIwMjUgYXQgMTI6MTY6NTggUE0=?=
Message-ID: <3cb5d201-ab8c-53fa-bd65-c594a6ccca74@ms29.hinet.net>
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Sep 2025 10:16:58 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-HiNet-Brightmail: Spam
X-CMAE-Score: 100
X-CMAE-Analysis: v=2.4 cv=KelxshYD c=0 sm=1 tr=0 ts=68c3f31c
	p=OrFXhexWvejrBOeqCD4A:9 a=nESGgMvO2jw7tQhjmqxCuQ==:117 a=IkcTkHD0fZMA:10
	a=5KLPUuaC_9wA:10

Hi Kvm,

Please provide a quote for your products:

Include:
1.Pricing (per unit)
2.Delivery cost & timeline
3.Quote expiry date

Deadline: September

Thanks!

Kamal Prasad

Albinayah Trading


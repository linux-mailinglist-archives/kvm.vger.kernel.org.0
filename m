Return-Path: <kvm+bounces-10026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4694686894B
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 07:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA7ED1F26FEC
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 06:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9120754FBD;
	Tue, 27 Feb 2024 06:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sonic.net header.i=@sonic.net header.b="RryI5HNK"
X-Original-To: kvm@vger.kernel.org
Received: from c.mail.sonic.net (c.mail.sonic.net [64.142.111.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397691E4AE;
	Tue, 27 Feb 2024 06:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.142.111.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709016747; cv=none; b=JJrN/mapIG5U+HeST4xVSZCjiayV0+/dwkZt1EZ6DhRVqlAxEvzuNNBl44tv9FVd6AmARZlR30kvdd9wO8VpITPvoqB465el0aUMIc0svBkmFuiZKaXbevpqtghOCxwDAIhC6tEbyRpRXz0AQRGOMmRJvbEmGn8ldr6JcjboMb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709016747; c=relaxed/simple;
	bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
	h=From:To:Date:MIME-Version:Subject:Message-ID:Content-type; b=T4Q/DuzrOUW8f02ago/DUIh6kxzpbMNU75qYK2qUXzLjAxjwbYGoeuk2okarAiwNPkFRSVeQBDBTbzhXXss8vnIsdmKsxGsqTF8BVaF7yb2xltaEwu+wQlIe7rntrtCKuuD3xrYa9lSNNToQ0MVJxrg/0PESjHQex1Pvn32H8Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sonic.net; spf=pass smtp.mailfrom=sonic.net; dkim=pass (2048-bit key) header.d=sonic.net header.i=@sonic.net header.b=RryI5HNK; arc=none smtp.client-ip=64.142.111.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sonic.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sonic.net
Received: from [192.168.1.94] (45-23-117-7.lightspeed.livnmi.sbcglobal.net [45.23.117.7])
	(authenticated bits=0)
	by c.mail.sonic.net (8.16.1/8.16.1) with ESMTPSA id 41R6qJT4030968
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 26 Feb 2024 22:52:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sonic.net; s=net23;
	t=1709016745; bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
	h=From:To:Date:MIME-Version:Subject:Message-ID:From:Subject;
	b=RryI5HNKNEyjYr7+X8KqDiWVWJzcyo8ij+ZPPjcsQeB7K/U9PPmALtG8lrgq9qICU
	 hkhs3oFgydBSkT4PEDSYxszJZYT/bAqgmYtIUmH49RIDXGo5N3Y/pb2BnkCLJdz1UZ
	 6PevrJN1tHVqlIPNfV/ecM+uAOnlCOBvi4t1Y7jgdNhFXi60Ji47quI1LkiEgK5TNC
	 XFGmFXhJDRQSgJ19iE8Dov4JxTo+fj8Y+wcVTCe2WF/UuhWrxwAu/ZA/cE7VUEAtaQ
	 MPJ9JITTijo1khW2fgmjZMllDNhbGG0vX6CfUyl5ba48tPKMIV1L/SiRTi7am2JQWp
	 USbpoDvj1znww==
From: delyan@sonic.net
To: keyrings+subscribe@vger.kernel.org, keyrings+unsubscribe@vger.kernel.org,
        keyrings@vger.kernel.org, kvm+subscribe@vger.kernel.org,
        kvm+unsubscribe@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc+subscribe@vger.kernel.org, kvm-ppc+unsubscribe@vger.kernel.org,
        kvm-ppc@vger.kernel.org, lartc+subscribe@vger.kernel.org,
        lartc+unsubscribe@vger.kernel.org, lartc@vger.kernel.org,
        linux-acpi+subscribe@vger.kernel.org,
        linux-acpi+unsubscribe@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-alpha+subscribe@vger.kernel.org,
        linux-alpha+unsubscribe@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-api+subscribe@vger.kernel.org
Date: Tue, 27 Feb 2024 01:52:19 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: subscribe
Message-ID: <65DD86A3.29102.445FAD58@delyan.sonic.net>
Priority: normal
X-mailer: Pegasus Mail for Windows (4.80.1028)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Sonic-CAuth: UmFuZG9tSVb9BhkJFO5Qzxh9/2zjUGyXXhnB3/s3jWtRqanB/qbw6f3MkzmhbdENIxm4Y9AyyS5E0DBDjnQuGwsxhW8HegI8
X-Sonic-ID: C;Cr9LwDzV7hGbeC5nR+6Zsg== M;UtgZwzzV7hGbeC5nR+6Zsg==
X-Spam-Flag: Unknown
X-Sonic-Spam-Details: not scanned (too big) by cerberusd

subscribe


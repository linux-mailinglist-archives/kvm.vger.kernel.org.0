Return-Path: <kvm+bounces-20532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5198917A9A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 10:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B81011C23C2F
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 08:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAEE1607B6;
	Wed, 26 Jun 2024 08:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zoho.com header.i=ToddAndMargo@zoho.com header.b="Lv5HBcm4"
X-Original-To: kvm@vger.kernel.org
Received: from sender4-pp-o91.zoho.com (sender4-pp-o91.zoho.com [136.143.188.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA215FA75
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 08:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719389628; cv=pass; b=H/rxJbLVUP5lrhmXCC2wpXxYYPQ8/a6wyhgt56HU4YLEaAbprzQh/tGEBnKrceHXE0xBFxQaJfDxV5iTUMhVqdQJfMugdanoHxPXMwJYGGkh6owNSczRPHjkGaUn1swEGiC2hHN4N1ehhpbdnpUfjxHUVbofwjE+m5mXwWlYjIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719389628; c=relaxed/simple;
	bh=vjyQh6Lnb/dhBS20q4sa/HtsnfRzFddK5U3+D3yj/m4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=HKmRdkEjyJXeUm+NOM9b50KLcMe2+SJUzpT1/i96RVfLxBNVD/JUWzhRuimHQRp71vcr5bR2yS283qXDHgAIi3c38keQ23f8xrDeRFXrYxOffPLd/+CRQMraVYpeU1YVdCO0wRjvr9Y+wpkrJc3kCBNuNmSYLKl6jRWLkXarCOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zoho.com; spf=pass smtp.mailfrom=zoho.com; dkim=pass (1024-bit key) header.d=zoho.com header.i=ToddAndMargo@zoho.com header.b=Lv5HBcm4; arc=pass smtp.client-ip=136.143.188.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zoho.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zoho.com
ARC-Seal: i=1; a=rsa-sha256; t=1719389625; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OOZ27MWdyj0biVxvsbgrBiCvktkhYoMl/YZ+ivJggNpVEdBscFpUGBNuSIKW8YcwRPdT/q0wow8GvAqzwLeShWwoehjBcEaYZPHB5PEZWX1EWGmzc61mXqSiupZE6c3l6BWU1T3z1uK0LHGZp91QzyEAruiF6PXvCy0oqus4dUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1719389625; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=wZbzsMvHFqVEef8goKnUx6Au2p32aFS0Ys4pF0Gk7B8=; 
	b=fUMtVwxWP7njmh5Ns+zGhmV+J86XDuKEZlGu6GoSrhnvrbz09hiS7Zo80uJKUcXa8QujNht+H1NldLTh0fuhrJXh67YwYQeB+T6KHP7noW+4FhuEUN0vIsj6ruZ5pKaEr9I6w2GKcPtddfZJiQ3edMw0x9yY4JahrhKfbHEjZAc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zoho.com;
	spf=pass  smtp.mailfrom=ToddAndMargo@zoho.com;
	dmarc=pass header.from=<ToddAndMargo@zoho.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1719389625;
	s=zm2022; d=zoho.com; i=ToddAndMargo@zoho.com;
	h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Content-Type:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To:Cc;
	bh=wZbzsMvHFqVEef8goKnUx6Au2p32aFS0Ys4pF0Gk7B8=;
	b=Lv5HBcm4yDHF/Jrj84/iExppmET53nPvWcE+O9bpCptejYECoO/zTacSzl46w94C
	4zuyhhAu3zPSsduAYHDJ1oodi5K5i1Co7VSQFzvnMNJCFrQrP98A2MtIqIsU2GFMBNC
	bg/9BeBtMEPynS8jpn9t+6dKXra3jmyt880AAdEI=
Received: by mx.zohomail.com with SMTPS id 171938962411856.06237972413203;
	Wed, 26 Jun 2024 01:13:44 -0700 (PDT)
Message-ID: <8f0e51ba-c4f6-421d-98a6-e0a3052ee8d7@zoho.com>
Date: Wed, 26 Jun 2024 01:13:43 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: ToddAndMargo <ToddAndMargo@zoho.com>
Subject: How do I ShareHost Files With KVM
To: kvm@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Feedback-ID: rr080112276767779e494b98a52e052ac90000f20e894ccfde966984488ee4d54aee360214c0d40c0c955b17:zu08011226ae25d4112ffca76e505b314c000075bf07a257e8082f24a49413823cc0ab53a4404fbf9e2291:rf08011226e250669d29cdfb2b550a3fea00005369f3383118df0ba1a2f8d26b6b324e39a890cc81952875:ZohoMail
X-ZohoMailClient: External

Hi All,

Fedora 39
qemu-kvm-8.1.3-5.fc39.x86_64
virt-manager-4.1.0-3.fc39.noarch

Windows 11

How do I Share Host Files (Fedora 39) with
Windows 11 (client) with KVM?

I have been reading this virt-manager how to:
     https://chrisirwin.ca/posts/sharing-host-files-with-kvm/

He is leaving out how to mount in Windows
and his "Filesystem Passthrough"
 
https://chrisirwin.ca/posts/sharing-host-files-with-kvm/add-filesystem.png

is a lot different than mine
     https://imgur.com/pqPcLo0.png

Anyone have a better howto?
-T


-- 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Computers are like air conditioners.
They malfunction when you open windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


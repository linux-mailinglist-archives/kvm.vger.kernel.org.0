Return-Path: <kvm+bounces-42615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2BAA7B25C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 01:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4F2418870A3
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046F21D619F;
	Thu,  3 Apr 2025 23:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="iliA+eEs"
X-Original-To: kvm@vger.kernel.org
Received: from ci74p00im-qukt09081502.me.com (ci74p00im-qukt09081502.me.com [17.57.156.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013E818DB29
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 23:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.57.156.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743722463; cv=none; b=cv0/WrHWboetjI+eahHOvyq8U2gkXIn9TMue3EtLLmOC4j5xtIZvQH5BiKRrFmqrMI0pCaWONiMSE6toQHQqNyc08JcExzisuwmeVuDHGbV25dMbeRbyaPNL2/LeIWD5nC3DOyzUcK2p+FYFq5VuLwJTORCtONHh01L2xQT+Hck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743722463; c=relaxed/simple;
	bh=oQVrm4JM1X0wDCMXvmOHv4D9tQl39pOLC72bTquZ9bE=;
	h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:Cc:To; b=CDZxmB/DtcD867KbVtWYSrnpfAXiPMhZIlOFZOqbuDyShRr5SgPnXi22uAJc6MtzEo7j98W/zfSet0aF1NDWSvE5CnxeTYcnCu6avlTHzsdr0YDcnRgX5srhi6re/sqyYu+yX4KTNvq45YmuJQuNmOxiuNsElnljj5mN8PO6Hfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=iliA+eEs; arc=none smtp.client-ip=17.57.156.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; bh=oQVrm4JM1X0wDCMXvmOHv4D9tQl39pOLC72bTquZ9bE=;
	h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To:x-icloud-hme;
	b=iliA+eEson9LQxxRXN2s6btoqNMlZdEJHHbxsDUOY3symniZj/S27dOX0k3JE7fjr
	 tL4r14VJDQlsYczhCop4OWF3sxW0/QH6e1GP09+Upy48eKHH2OAdEewWYjN9RBVETj
	 aR4RXzgQ2SVujEGAfcwCKJJDI3b9oFFgRyfkKJjCpMwhCX8J3iA7wAXHm2YUiVpYvG
	 QP/qaonHUBw3BIQSKCx7do6EQ+3/UfU58zY1aZYy5ojxGtNAsneuCjT4BtsmuAyW6f
	 6rTbOuYsKsE28lyzWdVw3no3rlNf/0mzddAC26G80RW8Salpz/NvvjePcHUYhGt867
	 7r1WSbYpTj0rw==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
	by ci74p00im-qukt09081502.me.com (Postfix) with ESMTPSA id 14891284023C;
	Thu,  3 Apr 2025 23:20:57 +0000 (UTC)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: witalihaschyts@icloud.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Date: Thu, 3 Apr 2025 18:20:34 -0500
Subject: Re: [PATCH v6 41/60] hw/i386: add option to forcibly report edge trigger in acpi tables
Message-Id: <322E5E0C-81B9-4DAD-8029-31BC02FA82D3@icloud.com>
Cc: anisinha@redhat.com, armbru@redhat.com, berrange@redhat.com,
 cohuck@redhat.com, eblake@redhat.com, imammedo@redhat.com, kvm@vger.kernel.org,
 marcel.apfelbaum@gmail.com, mst@redhat.com, mtosatti@redhat.com,
 pbonzini@redhat.com, philmd@linaro.org, qemu-devel@nongnu.org,
 richard.henderson@linaro.org, rick.p.edgecombe@intel.com, riku.voipio@iki.fi,
 wangyanan55@huawei.com, zhao1.liu@intel.com
To: xiaoyao.li@intel.com
X-Mailer: iPhone Mail (22F5042g)
X-Proofpoint-ORIG-GUID: 0nZeRHqui77-FwEKk6YlLfqqkkz5ZOnU
X-Proofpoint-GUID: 0nZeRHqui77-FwEKk6YlLfqqkkz5ZOnU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_10,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 clxscore=1011
 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=662
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2504030124


Sent from my iPhone


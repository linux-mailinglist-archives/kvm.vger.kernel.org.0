Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADDF26DEFE
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 17:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgIQPDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 11:03:25 -0400
Received: from sender4-of-o57.zoho.com ([136.143.188.57]:21763 "EHLO
        sender4-of-o57.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgIQPDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 11:03:05 -0400
X-Greylist: delayed 969 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 11:03:05 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1600353969; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=DbYGZlMDzwTf02Kt5am27UnrChrbYjJeHXPrtG5DabquV7FwtTvpri+3YWXjZwW9VbTd707jpSIwl7mKFIEUek8epVuUUPoOrnK7ezD+Gx+JxZiwIACHTSjI5FLfGJLVWfLMPtMwnlvAPRjRexEhiim8SnZMG1pJkBgi+IuiszM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1600353969; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=wpKa+E1ymNcu/wy5Xg9uB9XjbsDZo8zAUudFxKgMo4A=; 
        b=dgzXQpbAF+O4KX/WYdO6Ckk9YPmfSp4mOXBhlf2Mdd6P3TBB9TEWdBihGtEbfnGywQn9zP0RjjMuulKybPbFgwkYxkUUw7MqYFDtO0OXTaKT+C+rp42bcG5COAsoONeiHNHIls6JhaC5Okjqe062shoCzpgEQBg/s7Ba2yPAQUY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1600353966591282.5282417696268; Thu, 17 Sep 2020 07:46:06 -0700 (PDT)
Subject: Re: [PATCH v4 0/5] s390x/pci: Accomodate vfio DMA limiting
Message-ID: <160035396423.8478.4968781368528580151@66eaa9a8a123>
Reply-To: <qemu-devel@nongnu.org>
In-Reply-To: <1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     mjrosato@linux.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, thuth@redhat.com,
        kvm@vger.kernel.org, pmorel@linux.ibm.com, david@redhat.com,
        schnelle@linux.ibm.com, qemu-devel@nongnu.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, qemu-s390x@nongnu.org, mst@redhat.com,
        pbonzini@redhat.com, philmd@redhat.com, rth@twiddle.net
Date:   Thu, 17 Sep 2020 07:46:06 -0700 (PDT)
X-ZohoMailClient: External
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8xNjAwMzUyNDQ1LTIxMTEwLTEt
Z2l0LXNlbmQtZW1haWwtbWpyb3NhdG9AbGludXguaWJtLmNvbS8KCgoKSGksCgpUaGlzIHNlcmll
cyBmYWlsZWQgdGhlIGRvY2tlci1xdWlja0BjZW50b3M3IGJ1aWxkIHRlc3QuIFBsZWFzZSBmaW5k
IHRoZSB0ZXN0aW5nIGNvbW1hbmRzIGFuZAp0aGVpciBvdXRwdXQgYmVsb3cuIElmIHlvdSBoYXZl
IERvY2tlciBpbnN0YWxsZWQsIHlvdSBjYW4gcHJvYmFibHkgcmVwcm9kdWNlIGl0CmxvY2FsbHku
CgoKCgoKClRoZSBmdWxsIGxvZyBpcyBhdmFpbGFibGUgYXQKaHR0cDovL3BhdGNoZXcub3JnL2xv
Z3MvMTYwMDM1MjQ0NS0yMTExMC0xLWdpdC1zZW5kLWVtYWlsLW1qcm9zYXRvQGxpbnV4LmlibS5j
b20vdGVzdGluZy5kb2NrZXItcXVpY2tAY2VudG9zNy8/dHlwZT1tZXNzYWdlLgotLS0KRW1haWwg
Z2VuZXJhdGVkIGF1dG9tYXRpY2FsbHkgYnkgUGF0Y2hldyBbaHR0cHM6Ly9wYXRjaGV3Lm9yZy9d
LgpQbGVhc2Ugc2VuZCB5b3VyIGZlZWRiYWNrIHRvIHBhdGNoZXctZGV2ZWxAcmVkaGF0LmNvbQ==

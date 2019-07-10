Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431EC6436E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 10:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfGJIQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 04:16:37 -0400
Received: from sender-of-o52.zoho.com ([135.84.80.217]:21423 "EHLO
        sender-of-o52.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfGJIQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 04:16:37 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 04:16:37 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1562745686; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=QIjzXRc/Fyn3fjhCkRrKHbV7OpvAso+gWG3CI1trrJ+F68Y2f/UrK97G156R6Ob1kPgyLNo9tRIpvVMPWJ0GIhPGfL5NN+GpZD/oxbLDZR31jMxiD12owH3K19YvfxEEDt9aXsaQ2NMwWG7ez3YAJhdvCyW1/N5oAQFwSmBoi1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1562745686; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To:ARC-Authentication-Results; 
        bh=fQE1vMIVUHwWw+8vyChBuRhktnZTVWe/PYJOzdaqBjE=; 
        b=U9OiPeio31FxF+zEj2CeWUOpPSHg6cJ52AxP922RlNHG1QSmWW8fJGy0gHytgV6txWozM8JSGVjwPvco8hrEeTEBl5d7ugDt890rdBzzpGFhlDNy/VrOksZeAVVNV6fmKgXc/2VxJOCzqM6qBvqyPsyW6VlDJmT4HFjj4B4KRMY=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 156274568614918.321931122812884; Wed, 10 Jul 2019 01:01:26 -0700 (PDT)
Message-ID: <156274568499.3735.6585989280648335588@c4a48874b076>
Subject: Re: [Qemu-devel] [PATCH] target-i386: adds PV_SCHED_YIELD CPUID feature bit
In-Reply-To: <1562745044-7838-1-git-send-email-wanpengli@tencent.com>
Reply-To: <qemu-devel@nongnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     kernellwp@gmail.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        ehabkost@redhat.com, rkrcmar@redhat.com
Date:   Wed, 10 Jul 2019 01:01:26 -0700 (PDT)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8xNTYyNzQ1MDQ0LTc4MzgtMS1n
aXQtc2VuZC1lbWFpbC13YW5wZW5nbGlAdGVuY2VudC5jb20vCgoKCkhpLAoKVGhpcyBzZXJpZXMg
ZmFpbGVkIHRoZSBhc2FuIGJ1aWxkIHRlc3QuIFBsZWFzZSBmaW5kIHRoZSB0ZXN0aW5nIGNvbW1h
bmRzIGFuZAp0aGVpciBvdXRwdXQgYmVsb3cuIElmIHlvdSBoYXZlIERvY2tlciBpbnN0YWxsZWQs
IHlvdSBjYW4gcHJvYmFibHkgcmVwcm9kdWNlIGl0CmxvY2FsbHkuCgo9PT0gVEVTVCBTQ1JJUFQg
QkVHSU4gPT09CiMhL2Jpbi9iYXNoCm1ha2UgZG9ja2VyLWltYWdlLWZlZG9yYSBWPTEgTkVUV09S
Sz0xCnRpbWUgbWFrZSBkb2NrZXItdGVzdC1kZWJ1Z0BmZWRvcmEgVEFSR0VUX0xJU1Q9eDg2XzY0
LXNvZnRtbXUgSj0xNCBORVRXT1JLPTEKPT09IFRFU1QgU0NSSVBUIEVORCA9PT0KCiAgQ0MgICAg
ICB4ODZfNjQtc29mdG1tdS90cmFjZS9jb250cm9sLXRhcmdldC5vCiAgQ0MgICAgICB4ODZfNjQt
c29mdG1tdS9nZGJzdHViLXhtbC5vCiAgQ0MgICAgICB4ODZfNjQtc29mdG1tdS90cmFjZS9nZW5l
cmF0ZWQtaGVscGVycy5vCi90bXAvcWVtdS10ZXN0L3NyYy90YXJnZXQvaTM4Ni9jcHUuYzo5MDk6
MTk6IGVycm9yOiBtaXNzaW5nIHRlcm1pbmF0aW5nICciJyBjaGFyYWN0ZXIgWy1XZXJyb3IsLVdp
bnZhbGlkLXBwLXRva2VuXQogICAgICAgICAgICBOVUxMLCAia3ZtLXB2LXNjaGVkLXlpZWxkJywg
TlVMTCwgTlVMTCwKICAgICAgICAgICAgICAgICAgXgovdG1wL3FlbXUtdGVzdC9zcmMvdGFyZ2V0
L2kzODYvY3B1LmM6OTA5OjE5OiBlcnJvcjogZXhwZWN0ZWQgZXhwcmVzc2lvbgoyIGVycm9ycyBn
ZW5lcmF0ZWQuCm1ha2VbMV06ICoqKiBbL3RtcC9xZW11LXRlc3Qvc3JjL3J1bGVzLm1hazo2OTog
dGFyZ2V0L2kzODYvY3B1Lm9dIEVycm9yIDEKbWFrZVsxXTogKioqIFdhaXRpbmcgZm9yIHVuZmlu
aXNoZWQgam9icy4uLi4KCgpUaGUgZnVsbCBsb2cgaXMgYXZhaWxhYmxlIGF0Cmh0dHA6Ly9wYXRj
aGV3Lm9yZy9sb2dzLzE1NjI3NDUwNDQtNzgzOC0xLWdpdC1zZW5kLWVtYWlsLXdhbnBlbmdsaUB0
ZW5jZW50LmNvbS90ZXN0aW5nLmFzYW4vP3R5cGU9bWVzc2FnZS4KLS0tCkVtYWlsIGdlbmVyYXRl
ZCBhdXRvbWF0aWNhbGx5IGJ5IFBhdGNoZXcgW2h0dHBzOi8vcGF0Y2hldy5vcmcvXS4KUGxlYXNl
IHNlbmQgeW91ciBmZWVkYmFjayB0byBwYXRjaGV3LWRldmVsQHJlZGhhdC5jb20=


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9454327346F
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 22:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgIUU60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 16:58:26 -0400
Received: from sender4-of-o57.zoho.com ([136.143.188.57]:21756 "EHLO
        sender4-of-o57.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgIUU6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 16:58:25 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1600721770; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Y4gWBlSWg+0yA/gHFZUKbv/aMAk9AUKqn8ASWkrnMSVwHS0GeyNyzgzCexb3E2K2o5ehvvuzsOYYReCGDtDPk/SAS3am04HqItocyU51l7yMP7T6cSS9fbYrLRT8n/VD3rIzcetDKYwbVfXBmLVrbYWrYWTQZyHyseocv8tVWWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1600721770; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=rh/2U/XNxyoy7UhLIqfqEI+QrbkE8n1oyRx5QDn7yPw=; 
        b=AEvoK4QvKTNtA2Dhmd8SOhTcxIYiuX9jnIQyDmU6Mf+vXAl+XD9/iL6g2oaUpGaileEIQc23xBhZ7ucl/eqZlC8Q6aXZvPdBPq+kUVB5Cx9HxMAym0aOtxOnlplteFrjYMJyqUDcFvCKJeWj5yYtORNVSPSteOElQw2swJ+mY6U=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1600721768767227.91629257311638; Mon, 21 Sep 2020 13:56:08 -0700 (PDT)
Subject: Re: [PATCH] qemu/atomic.h: prefix qemu_ to solve <stdatomic.h> collisions
Message-ID: <160072176188.21069.7427016597134663502@66eaa9a8a123>
Reply-To: <qemu-devel@nongnu.org>
In-Reply-To: <20200921162346.188997-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     stefanha@redhat.com
Cc:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, fam@euphon.net,
        ysato@users.sourceforge.jp, berto@igalia.com, jslaby@suse.cz,
        rth@twiddle.net, pl@kamp.de, david@redhat.com, pasic@linux.ibm.com,
        eblake@redhat.com, mreitz@redhat.com, marcandre.lureau@redhat.com,
        berrange@redhat.com, palmer@dabbelt.com, armbru@redhat.com,
        kvm@vger.kernel.org, yuval.shaia.ml@gmail.com, mst@redhat.com,
        cohuck@redhat.com, qemu-block@nongnu.org, sw@weilnetz.de,
        dgilbert@redhat.com, mdroth@linux.vnet.ibm.com,
        jiaxun.yang@flygoat.com, jsnow@redhat.com, jcmvbkbc@gmail.com,
        marcel.apfelbaum@gmail.com, Alistair.Francis@wdc.com,
        aurelien@aurel32.net, aleksandar.rikalo@syrmia.com,
        chenhc@lemote.com, aleksandar.qemu.devel@gmail.com,
        ehabkost@redhat.com, borntraeger@de.ibm.com,
        sunilmut@microsoft.com, thuth@redhat.com, pbonzini@redhat.com,
        sstabellini@kernel.org, anthony.perard@citrix.com,
        kraxel@redhat.com, peter.maydell@linaro.org, namei.unix@gmail.com,
        paul@xen.org, stefanha@redhat.com, kwolf@redhat.com,
        kbastian@mail.uni-paderborn.de, sagark@eecs.berkeley.edu,
        jasowang@redhat.com, laurent@vivier.eu,
        xen-devel@lists.xenproject.org, mjrosato@linux.ibm.com,
        sheepdog@lists.wpkg.org, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, quintela@redhat.com,
        zhang.zhanghailiang@huawei.com
Date:   Mon, 21 Sep 2020 13:56:08 -0700 (PDT)
X-ZohoMailClient: External
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8yMDIwMDkyMTE2MjM0Ni4xODg5
OTctMS1zdGVmYW5oYUByZWRoYXQuY29tLwoKCgpIaSwKClRoaXMgc2VyaWVzIHNlZW1zIHRvIGhh
dmUgc29tZSBjb2Rpbmcgc3R5bGUgcHJvYmxlbXMuIFNlZSBvdXRwdXQgYmVsb3cgZm9yCm1vcmUg
aW5mb3JtYXRpb246CgpUeXBlOiBzZXJpZXMKTWVzc2FnZS1pZDogMjAyMDA5MjExNjIzNDYuMTg4
OTk3LTEtc3RlZmFuaGFAcmVkaGF0LmNvbQpTdWJqZWN0OiBbUEFUQ0hdIHFlbXUvYXRvbWljLmg6
IHByZWZpeCBxZW11XyB0byBzb2x2ZSA8c3RkYXRvbWljLmg+IGNvbGxpc2lvbnMKCj09PSBURVNU
IFNDUklQVCBCRUdJTiA9PT0KIyEvYmluL2Jhc2gKZ2l0IHJldi1wYXJzZSBiYXNlID4gL2Rldi9u
dWxsIHx8IGV4aXQgMApnaXQgY29uZmlnIC0tbG9jYWwgZGlmZi5yZW5hbWVsaW1pdCAwCmdpdCBj
b25maWcgLS1sb2NhbCBkaWZmLnJlbmFtZXMgVHJ1ZQpnaXQgY29uZmlnIC0tbG9jYWwgZGlmZi5h
bGdvcml0aG0gaGlzdG9ncmFtCi4vc2NyaXB0cy9jaGVja3BhdGNoLnBsIC0tbWFpbGJhY2sgYmFz
ZS4uCj09PSBURVNUIFNDUklQVCBFTkQgPT09CgpVcGRhdGluZyAzYzhjZjVhOWMyMWZmODc4MjE2
NGQxZGVmN2Y0NGJkODg4NzEzMzg0CkZyb20gaHR0cHM6Ly9naXRodWIuY29tL3BhdGNoZXctcHJv
amVjdC9xZW11CiAtIFt0YWcgdXBkYXRlXSAgICAgIHBhdGNoZXcvMjAyMDA5MTgxMDM0MzAuMjk3
MTY3LTEtdGh1dGhAcmVkaGF0LmNvbSAtPiBwYXRjaGV3LzIwMjAwOTE4MTAzNDMwLjI5NzE2Ny0x
LXRodXRoQHJlZGhhdC5jb20KU3dpdGNoZWQgdG8gYSBuZXcgYnJhbmNoICd0ZXN0JwoyNWNhNzAy
IHFlbXUvYXRvbWljLmg6IHByZWZpeCBxZW11XyB0byBzb2x2ZSA8c3RkYXRvbWljLmg+IGNvbGxp
c2lvbnMKCj09PSBPVVRQVVQgQkVHSU4gPT09CkVSUk9SOiBNYWNyb3Mgd2l0aCBtdWx0aXBsZSBz
dGF0ZW1lbnRzIHNob3VsZCBiZSBlbmNsb3NlZCBpbiBhIGRvIC0gd2hpbGUgbG9vcAojMjk2ODog
RklMRTogaW5jbHVkZS9xZW11L2F0b21pYy5oOjE1MjoKKyNkZWZpbmUgcWVtdV9hdG9taWNfcmN1
X3JlYWRfX25vY2hlY2socHRyLCB2YWxwdHIpICAgICAgXAogICAgIF9fYXRvbWljX2xvYWQocHRy
LCB2YWxwdHIsIF9fQVRPTUlDX1JFTEFYRUQpOyAgICAgICBcCiAgICAgc21wX3JlYWRfYmFycmll
cl9kZXBlbmRzKCk7CgpFUlJPUjogc3BhY2UgcmVxdWlyZWQgYmVmb3JlIHRoYXQgJyonIChjdHg6
VnhCKQojMzEyMzogRklMRTogaW5jbHVkZS9xZW11L2F0b21pYy5oOjM0NzoKKyNkZWZpbmUgcWVt
dV9hdG9taWNfcmVhZF9fbm9jaGVjayhwKSAoKihfX3R5cGVvZl9fKCoocCkpIHZvbGF0aWxlKikg
KHApKQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBeCgpFUlJPUjogVXNlIG9mIHZvbGF0aWxlIGlzIHVzdWFsbHkgd3Jvbmcs
IHBsZWFzZSBhZGQgYSBjb21tZW50CiMzMTIzOiBGSUxFOiBpbmNsdWRlL3FlbXUvYXRvbWljLmg6
MzQ3OgorI2RlZmluZSBxZW11X2F0b21pY19yZWFkX19ub2NoZWNrKHApICgqKF9fdHlwZW9mX18o
KihwKSkgdm9sYXRpbGUqKSAocCkpCgpFUlJPUjogc3BhY2UgcmVxdWlyZWQgYmVmb3JlIHRoYXQg
JyonIChjdHg6VnhCKQojMzEyNTogRklMRTogaW5jbHVkZS9xZW11L2F0b21pYy5oOjM0OToKKyAg
ICAoKCooX190eXBlb2ZfXygqKHApKSB2b2xhdGlsZSopIChwKSkgPSAoaSkpCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBeCgpFUlJPUjogVXNlIG9mIHZvbGF0aWxlIGlzIHVzdWFs
bHkgd3JvbmcsIHBsZWFzZSBhZGQgYSBjb21tZW50CiMzMTI1OiBGSUxFOiBpbmNsdWRlL3FlbXUv
YXRvbWljLmg6MzQ5OgorICAgICgoKihfX3R5cGVvZl9fKCoocCkpIHZvbGF0aWxlKikgKHApKSA9
IChpKSkKCkVSUk9SOiBzcGFjZSByZXF1aXJlZCBhZnRlciB0aGF0ICcsJyAoY3R4OlZ4VikKIzMx
MzA6IEZJTEU6IGluY2x1ZGUvcWVtdS9hdG9taWMuaDozNTI6CisjZGVmaW5lIHFlbXVfYXRvbWlj
X3NldChwdHIsIGkpICAgICBxZW11X2F0b21pY19zZXRfX25vY2hlY2socHRyLGkpCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
XgoKRVJST1I6IG1lbW9yeSBiYXJyaWVyIHdpdGhvdXQgY29tbWVudAojMzIwNTogRklMRTogaW5j
bHVkZS9xZW11L2F0b21pYy5oOjQxMDoKKyNkZWZpbmUgcWVtdV9hdG9taWNfeGNoZyhwdHIsIGkp
IChzbXBfbWIoKSwgX19zeW5jX2xvY2tfdGVzdF9hbmRfc2V0KHB0ciwgaSkpCgpXQVJOSU5HOiBC
bG9jayBjb21tZW50cyB1c2UgYSBsZWFkaW5nIC8qIG9uIGEgc2VwYXJhdGUgbGluZQojMzI4MDog
RklMRTogaW5jbHVkZS9xZW11L2F0b21pYy5oOjQ2MjoKKy8qIHFlbXVfYXRvbWljX21iX3JlYWQv
c2V0IHNlbWFudGljcyBtYXAgSmF2YSB2b2xhdGlsZSB2YXJpYWJsZXMuIFRoZXkgYXJlCgpXQVJO
SU5HOiBCbG9jayBjb21tZW50cyB1c2UgYSBsZWFkaW5nIC8qIG9uIGEgc2VwYXJhdGUgbGluZQoj
NjM5NDogRklMRTogdXRpbC9iaXRtYXAuYzoyMTQ6CisgICAgICAgIC8qIElmIHdlIGF2b2lkZWQg
dGhlIGZ1bGwgYmFycmllciBpbiBxZW11X2F0b21pY19vcigpLCBpc3N1ZSBhCgpXQVJOSU5HOiBC
bG9jayBjb21tZW50cyB1c2UgYSBsZWFkaW5nIC8qIG9uIGEgc2VwYXJhdGUgbGluZQojNzQzMDog
RklMRTogdXRpbC9yY3UuYzo4NToKKyAgICAgICAgLyogSW5zdGVhZCBvZiB1c2luZyBxZW11X2F0
b21pY19tYl9zZXQgZm9yIGluZGV4LT53YWl0aW5nLCBhbmQKCldBUk5JTkc6IEJsb2NrIGNvbW1l
bnRzIHVzZSBhIGxlYWRpbmcgLyogb24gYSBzZXBhcmF0ZSBsaW5lCiM3NDU2OiBGSUxFOiB1dGls
L3JjdS5jOjE1NDoKKyAgICAgICAgLyogSW4gZWl0aGVyIGNhc2UsIHRoZSBxZW11X2F0b21pY19t
Yl9zZXQgYmVsb3cgYmxvY2tzIHN0b3JlcyB0aGF0IGZyZWUKCnRvdGFsOiA3IGVycm9ycywgNCB3
YXJuaW5ncywgNjUwNyBsaW5lcyBjaGVja2VkCgpDb21taXQgMjVjYTcwMjliMmYyIChxZW11L2F0
b21pYy5oOiBwcmVmaXggcWVtdV8gdG8gc29sdmUgPHN0ZGF0b21pYy5oPiBjb2xsaXNpb25zKSBo
YXMgc3R5bGUgcHJvYmxlbXMsIHBsZWFzZSByZXZpZXcuICBJZiBhbnkgb2YgdGhlc2UgZXJyb3Jz
CmFyZSBmYWxzZSBwb3NpdGl2ZXMgcmVwb3J0IHRoZW0gdG8gdGhlIG1haW50YWluZXIsIHNlZQpD
SEVDS1BBVENIIGluIE1BSU5UQUlORVJTLgo9PT0gT1VUUFVUIEVORCA9PT0KClRlc3QgY29tbWFu
ZCBleGl0ZWQgd2l0aCBjb2RlOiAxCgoKVGhlIGZ1bGwgbG9nIGlzIGF2YWlsYWJsZSBhdApodHRw
Oi8vcGF0Y2hldy5vcmcvbG9ncy8yMDIwMDkyMTE2MjM0Ni4xODg5OTctMS1zdGVmYW5oYUByZWRo
YXQuY29tL3Rlc3RpbmcuY2hlY2twYXRjaC8/dHlwZT1tZXNzYWdlLgotLS0KRW1haWwgZ2VuZXJh
dGVkIGF1dG9tYXRpY2FsbHkgYnkgUGF0Y2hldyBbaHR0cHM6Ly9wYXRjaGV3Lm9yZy9dLgpQbGVh
c2Ugc2VuZCB5b3VyIGZlZWRiYWNrIHRvIHBhdGNoZXctZGV2ZWxAcmVkaGF0LmNvbQ==

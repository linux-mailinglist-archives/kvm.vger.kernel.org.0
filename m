Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B984716BB4C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 08:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgBYHxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 02:53:23 -0500
Received: from out0-138.mail.aliyun.com ([140.205.0.138]:40245 "EHLO
        out0-138.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729111AbgBYHxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 02:53:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1582617199; h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type;
        bh=/puhnCRsreW0Ri4vztcPQdwutZNhsyKqRStaan379Pc=;
        b=vcnxWliAjKnw0QmJv+mfVhYVY5ahTkbQqi3ARAi4BWNDotPq8gVuQfjIy50MzIocMHyaGqu8bwHoV7Og8z/Ili56Q5i1X1wcLTg/t1uvFsaZWUOABpgU4cTCrYrRydDtBwZWqu7ANo3K9ipIs4gD3Tm2FJrjqRMFOp2r85QnSok=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03293;MF=bangcai.hrg@alibaba-inc.com;NM=1;PH=DW;RN=16;SR=0;TI=W4_5790132_DEFAULT_0AB10216_1582615630451_o7001c563;
Received: from WS-web (bangcai.hrg@alibaba-inc.com[W4_5790132_DEFAULT_0AB10216_1582615630451_o7001c563]) by e01e04486.eu6 at Tue, 25 Feb 2020 15:53:17 +0800
Date:   Tue, 25 Feb 2020 15:53:17 +0800
From:   "=?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?=" <bangcai.hrg@alibaba-inc.com>
To:     "Wanpeng Li" <kernellwp@gmail.com>
Cc:     "namit" <namit@vmware.com>, "peterz" <peterz@infradead.org>,
        "pbonzini" <pbonzini@redhat.com>,
        "dave.hansen" <dave.hansen@intel.com>, "mingo" <mingo@redhat.com>,
        "tglx" <tglx@linutronix.de>, "x86" <x86@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "dave.hansen" <dave.hansen@linux.intel.com>, "bp" <bp@alien8.de>,
        "luto" <luto@kernel.org>, "kvm" <kvm@vger.kernel.org>,
        "=?UTF-8?B?5p6X5rC45ZCsKOa1t+aeqyk=?=" <yongting.lyt@alibaba-inc.com>,
        "=?UTF-8?B?5ZC05ZCv57++KOWQr+e/vik=?=" <qixuan.wqx@alibaba-inc.com>,
        "herongguang" <herongguang@linux.alibaba.com>
Reply-To: "=?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?=" 
          <bangcai.hrg@alibaba-inc.com>
Message-ID: <660daad7-afb0-496d-9f40-a1162d5451e2.bangcai.hrg@alibaba-inc.com>
Subject: =?UTF-8?B?5Zue5aSN77yaW1JGQ10gUXVlc3Rpb24gYWJvdXQgYXN5bmMgVExCIGZsdXNoIGFuZCBLVk0g?=
  =?UTF-8?B?cHYgdGxiIGltcHJvdmVtZW50cw==?=
X-Mailer: [Alimail-Mailagent revision 59873560][W4_5790132][DEFAULT][Chrome]
MIME-Version: 1.0
References: <07348bb2-c8a5-41d0-afca-26c1056570a5.bangcai.hrg@alibaba-inc.com>,<CANRm+CwZq=FbCwRcyO=C7YinLevmMuVVu9auwPqyho3o-4Y-wQ@mail.gmail.com>
x-aliyun-mail-creator: W4_5790132_DEFAULT_M2ITW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzgwLjAuMzk4Ny4xMTYgU2FmYXJpLzUzNy4zNg==3L
In-Reply-To: <CANRm+CwZq=FbCwRcyO=C7YinLevmMuVVu9auwPqyho3o-4Y-wQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBUdWUsIDI1IEZlYiAyMDIwIGF0IDEyOjEyLCDkvZXlrrnlhYko6YKm6YeHKSA8YmFuZ2Nh
aS5ocmdAYWxpYmFiYS1pbmMuY29tPiB3cm90ZToKPj4KPj4gSGkgdGhlcmUsCj4+Cj4+IEkgc2F3
IHRoaXMgYXN5bmMgVExCIGZsdXNoIHBhdGNoIGF0IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3Bh
dGNod29yay9wYXRjaC8xMDgyNDgxLyAsIGFuZCBJIGFtIHdvbmRlcmluZyBhZnRlciBvbmUgeWVh
ciwgZG8geW91IHRoaW5rIGlmIHRoaXMgcGF0Y2ggaXMgcHJhY3RpY2FsIG9yIHRoZXJlIGFyZSBm
dW5jdGlvbmFsIGZsYXdzPwo+PiBGcm9tIG15IFBPViwgTmFkYXYncyBwYXRjaCBzZWVtcyBoYXMg
bm8gb2J2aW91cyBmbGF3LiBCdXQgSSBhbSBub3QgZmFtaWxpYXIgYWJvdXQgdGhlIHJlbGF0aW9u
c2hpcCBiZXR3ZWVuIENQVSdzIHNwZWN1bGF0aW9uIGV4ZWMgYW5kIHN0YWxlIFRMQiwgc2luY2Ug
aXQncyB1c3VhbGx5IHRyYW5zcGFyZW50IGZyb20gcHJvZ3JhbWluZy4gSW4gd2hpY2ggY29uZGl0
aW9uIHdvdWxkIG1hY2hpbmUgY2hlY2sgb2NjdXJzPyBJcyB0aGVyZSBzb21lIHJlZmVyZW5jZSBJ
IGNhbiBsZWFybj8KPj4gQlRXLCBJIGFtIHRyeWluZyB0byBpbXByb3ZlIGt2bSBwdiB0bGIgZmx1
c2ggdGhhdCBpZiBhIHZDUFUgaXMgcHJlZW1wdGVkLCBhcyBpbml0aWF0aW5nIENQVSBpcyBub3Qg
c2VuZGluZyBJUEkgdG8gYW5kIHdhaXRpbmcgZm9yIHRoZSBwcmVlbXB0ZWQgdkNQVSwgd2hlbiB0
aGUgcHJlZW1wdGVkIHZDUFUgaXMgcmVzdW1pbmcsIEkgd2FudCB0aGUgVk1NIHRvIGluamVjdCBh
biBpbnRlcnJ1cHQsIHBlcmhhcHMgTk1JLCB0byB0aGUgdkNQVSBhbmQgbGV0dGluZyB2Q1BVIGZs
dXNoIFRMQiBpbnN0ZWFkIG9mIGZsdXNoIFRMQiBmb3IgdGhlIHZDUFUsIGluIGNhc2UgdGhlIHZD
UFUgaXMgbm90IGluIGtlcm5lbCBtb2RlIG9yIGRpc2FibGVkIGludGVycnVwdCwgb3RoZXJ3aXNl
IHN0aWNrIHRvIFZNTSBmbHVzaC4gU2luY2UgVk1NIGZsdXNoIHVzaW5nIElOVlZQSUQgd291bGQg
Zmx1c2ggYWxsIFRMQiBvZiBhbGwgUENJRCB0aHVzIGhhcyBzb21lIG5lZ2F0aXZlIHBlcmZvcm1h
bmNlIGltcGFjdGluZyBvbiB0aGUgcHJlZW1wdGVkIHZDUFUuIFNvIGlzIHRoZXJlIHNhbWUgcHJv
YmxlbSBhcyB0aGUgYXN5bmMgVExCIGZsdXNoIHBhdGNoPwoKPiBQViBUTEIgU2hvb3Rkb3duIGlz
IGRpc2FibGVkIGluIGRlZGljYXRlZCBzY2VuYXJpbywgSSBiZWxpZXZlIHRoZXJlCj4gYXJlIGFs
cmVhZHkgaGVhdnkgdGxiIG1pc3NlcyBpbiBvdmVyY29tbWl0IHNjZW5hcmlvcyBiZWZvcmUgdGhp
cwo+IGZlYXR1cmUsIHNvIGZsdXNoIGFsbCBUTEIgYXNzb2NpYXRlZCB3aXRoIG9uZSBzcGVjaWZp
YyBWUElEIHdpbGwgbm90Cj4gd29yc2UgdGhhdCBtdWNoLgoKSWYgdmNwdXMgcnVubmluZyBvbiBv
bmUgcGNwdSBpcyBsaW1pdGVkIHRvIGEgZmV3LCBmcm9tIG15IHRlc3QsIHRoZXJlIApjYW4gc3Rp
bGwgYmUgc29tZSBiZW5lZmljaWFsLiBFc3BlY2lhbGx5IGlmIHdlIGNhbiBtb3ZlIGFsbCB0aGUg
bG9naWMgdG8KVk1NIGVsaW1pbmF0aW5nIHdhaXRpbmcgb2YgSVBJLCBob3dldmVyIGNvcnJlY3Ru
ZXNzIG9mIGZ1bmN0aW9uYWxseSAKaXMgYSBjb25jZXJuLiBUaGlzIGlzIGFsc28gd2h5IEkgZm91
bmQgTmFkYXYncyBwYXRjaCwgZG8geW91IGhhdmUgCmFueSBhZHZpY2Ugb24gdGhpcz8=

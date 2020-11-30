Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1278F2C85BB
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 14:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgK3Nj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 08:39:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgK3Nj5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 08:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606743510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GIjdBqvhDJhg2PojQ0Ui4mKRox0t63heS3W65B6mV4c=;
        b=dDoSJ/PQGAeIv6iyfUNLhbOYUjFAXICqdW8za35eubfthteUPY5N/cl32iP0aQzFP+/zVT
        iQfx4f+UmY4kVgfQWfig3hSr+od54xGuZMHceOYnQ822yUcBsKTzC3KikgS9UNNnAclQ0r
        pFWNujEdmgS3Wdh54oWt8Xxdmy8I4n0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-2oNQQzvsNdiDskfIzqeO4g-1; Mon, 30 Nov 2020 08:38:25 -0500
X-MC-Unique: 2oNQQzvsNdiDskfIzqeO4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13168805BE3;
        Mon, 30 Nov 2020 13:38:24 +0000 (UTC)
Received: from starship (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA7CE5D9C0;
        Mon, 30 Nov 2020 13:38:19 +0000 (UTC)
Message-ID: <8f5505e3e0aecd15791e3236d98d45bcabf48c15.camel@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration (summary)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon, 30 Nov 2020 15:38:18 +0200
In-Reply-To: <20201130133559.233242-1-mlevitsk@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
Content-Type: multipart/mixed; boundary="=-DUQzlO94mllHXCRz4Pqm"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-DUQzlO94mllHXCRz4Pqm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

This is the summary of few things that I think are relevant.

Best regards,
	Maxim Levitsky

--=-DUQzlO94mllHXCRz4Pqm
Content-Disposition: attachment; filename="tsc.md"
Content-Transfer-Encoding: base64
Content-Type: text/markdown; name="tsc.md"; charset="UTF-8"

IyBSYW5kb20gdW5zeW5jaHJvbml6ZWQgcmFtYmxpbmdzIGFib3V0IHRoZSBUU0MgaW4gS1ZNL0xp
bnV4CgojIyBUaGUgS1ZNJ3MgbWFzdGVyIGNsb2NrCgpVbmRlciBhc3N1bXB0aW9uIHRoYXQKCmEu
IEhvc3QgVFNDIGlzIHN5bmNocm9uaXplZCBhbmQgc3RhYmxlICh3YXNuJ3QgbWFya2VkIGFzIHVu
c3RhYmxlKS4KCmIuIEd1ZXN0IFRTQyBpcyBzeW5jaHJvbml6ZWQ6CgogICAtIFdoZW4gZ3Vlc3Qg
c3RhcnRzIHJ1bm5pbmcsIGFsbCBpdHMgdkNQVXMgc3RhcnQgZnJvbSBUU0MgPSAwLgoKICAgLSBJ
ZiB3ZSBob3RwbHVnIGEgdkNQVSwgaXRzIFRTQyBpcyBzZXQgdG8gMCwgYnV0IHRoZSAna3ZtX3N5
bmNocm9uaXplX3RzYycKICAgICAoaXQgd2FzIHVzZWQgdG8gYmUgY2FsbGVkIGt2bV93cml0ZV90
c2MpLCBwcmFjdGljYWxseSBzcGVha2luZywKICAgICBqdXN0IHNldHMgdGhlIFRTQyB0byB0aGUg
c2FtZSB2YWx1ZSBhcyBvdGhlciB2Q1BVcyBhcmUgaGF2aW5nIHJpZ2h0IG5vdy4KCiAgICAgTGF0
ZXIgTGludXggd2lsbCB0cnkgdG8gc3luYyBpdCBhZ2FpbiwgYnV0IHNpbmNlIGl0IGlzIGFscmVh
ZHkgc3luY2hyb25pemVkCiAgICAgaXQgd29uJ3QgZG8gYW55dGhpbmcuIE90aGVyd2lzZSBpdCB1
c2VzIElBXzMyX01TUl9UU0NfQURKVVNUIHRvIGFkanVzdCBpdC4KICAgICAKICAgLSBJZiB0aGUg
Z3Vlc3Qgd3JpdGVzIHRoZSBUU0Mgd2UgdHJ5IHRvIGRldGVjdCBpZiBUU0MgaXMgc3RpbGwgc3lu
Y2VkLgogICAgIChXZSBkb24ndCBoYW5kbGUgVFNDIGFkanVzdG1lbnRzIGRvbmUgdmlhIElBXzMy
X01TUl9UU0NfQURKVVNUKS4KClRoZW4gdGhlIGt2bWNsb2NrIGlzIGRyaXZlbiBieSBhIHNpbmds
ZSBwYWlyIG9mIChuc2VjcywgdHNjKSBhbmQgdGhhdCBpcyB1c2VkCnRvIHVwZGF0ZSB0aGUga3Zt
Y2xvY2sgb24gYWxsIHZDUFVzLgoKVGhlIGFkdmFudGFnZSBvZiB0aGlzIGlzIHRoYXQgbm8gcmFu
ZG9tIGVycm9yIGNhbiBiZSBpbnRyb2R1Y2VkIGJ5IGNhbGN1bGF0aW5nCnRoaXMgcGFpciBvbiBl
YWNoIENQVS4KClBsdXMgYW5vdGhlciBhZHZhbnRhZ2UgaXMgdGhhdCBiZWluZyB2Q1BVIGludmFy
aWFudCwgZ3Vlc3QncyBrdm1jbG9jawppbXBsZW1lbnRhdGlvbiBjYW4gcmVhZCBpdCBpbiB1c2Vy
c3BhY2UuClRoaXMgaXMgc2lnbmFsZWQgYnkgc2V0dGluZyBLVk1fQ0xPQ0tfVFNDX1NUQUJMRSBm
bGFnIHZpYSBrdm1jbG9jayBpbnRlcmZhY2UuCgojIyBLVk0gYmVoYXZpb3Igd2hlbiB0aGUgaG9z
dCB0c2MgaXMgZGV0ZWN0ZWQgYXMgdW5zdGFibGUKCiogT24gZWFjaCAndXNlcnNwYWNlJyBWTSBl
bnRyeSAoYWthICd2Y3B1X2xvYWQnKSwgd2Ugc2V0IGd1ZXN0IHRzYyB0byBpdHMKICBsYXN0IHZh
bHVlIGNhcHR1cmVkIG9uIGxhc3QgdXNlcnNwYWNlIFZNIGV4aXQsCiAgYW5kIHdlIHNjaGVkdWxl
IGEgS1ZNIGNsb2NrIHVwZGF0ZSAoS1ZNX1JFUV9HTE9CQUxfQ0xPQ0tfVVBEQVRFKQogIAoqIE9u
IGVhY2ggS1ZNIGNsb2NrIHVwZGF0ZSwgd2UgJ2NhdGNodXAnIHRoZSB0c2MgdG8gdGhlIGtlcm5l
bCBjbG9jay4KCiogV2UgZG9uJ3QgdXNlIG1hc3RlcmNsb2NrCgojIyBUaGUgVFNDICdmZWF0dXJl
cycgaW4gdGhlIExpbnV4IGtlcm5lbAoKTGludXgga2VybmVsIGhhcyByb3VnaGx5IHNwZWFraW5n
IDQgY3B1ICdmZWF0dXJlcycgdGhhdCBkZWZpbmUgaXRzIHRyZWF0bWVudCBvZiBUU0MuClNvbWUg
b2YgdGhlc2UgZmVhdHVyZXMgYXJlIHNldCBmcm9tIENQVUlELCBzb21lIGFyZSBzZXQgd2hlbiBj
ZXJ0YWluIENQVSAKbW9kZWxzIGFyZSBkZXRlY3RlZCwgYW5kIHNvbWUgYXJlIHNldCB3aGVuIGEg
c3BlY2lmaWMgaHlwZXJ2aXNvciBpcyBkZXRlY3RlZC4KCiogWDg2X0ZFQVRVUkVfVFNDX0tOT1dO
X0ZSRVEKICBUaGlzIGlzIHRoZSBtb3N0IGhhcm1sZXNzIGZlYXR1cmUuIEl0IGlzIHNldCBieSB2
YXJpb3VzIGh5cGVydmlzb3JzLAogIChpbmNsdWRpbmcga3ZtY2xvY2spLCBhbmQgZm9yIHNvbWUg
SW50ZWwgbW9kZWxzLCB3aGVuIFRTQyBmcmVxdWVuY3kgY2FuCiAgYmUgb2J0YWluZWQgdmlhIGFu
IGludGVyZmFjZSAoUFYsIGNwdWlkLCBtc3IsIGV0YyksIHJhdGhlciB0aGFuIG1lYXN1cmluZyBp
dC4KCiogWDg2X0ZFQVRVUkVfTk9OU1RPUF9UU0MKICAKICBPbiByZWFsIGhhcmR3YXJlLCB0aGlz
IGZlYXR1cmUgaXMgc2V0IHdoZW4gQ1BVSUQgaGFzIHRoZSAnaW52dHNjJyBiaXQgc2V0LgogIEFu
ZCBpdCB0ZWxscyB0aGUga2VybmVsIHRoYXQgVFNDIGRvZXNuJ3Qgc3RvcCBpbiBsb3cgcG93ZXIg
aWRsZSBzdGF0ZXMuCiAgV2hlbiBhYnNlbnQsIGFuIGF0dGVtcHQgdG8gZW50ZXIgYSBsb3cgcG93
ZXIgaWRsZSBzdGF0ZSAoZS5nIEMyKSB3aWxsIG1hcmsKICB0aGUgVFNDIGFzIHVuc3RhYmxlLgog
IAogIFRoaXMgZmVhdHVyZSBoYXMgYWxzbyBhIGZyaWVuZCBjYWxsZWQgWDg2X0ZFQVRVUkVfTk9O
U1RPUF9UU0NfUzMsCiAgd2hpY2ggZG9lc24ndCBkbyBhbnl0aGluZyB0aGF0IGlzIHJlbGV2YW50
IHRvIEtWTS4KICAKICBJbiBhIFZNLCBvbiBvbmUgaGFuZCB0aGUgdkNQVSBpcyBpbnRlcnJ1cHRl
ZCBvZnRlbiBidXQgYXMgbG9uZyBhcyB0aGUgaG9zdCBUU0MKICBpcyBzdGFibGUsIHRoZSBndWVz
dCBUU0Mgc2hvdWxkIHJlbWFpbiBzdGFibGUgYXMgd2VsbC4KICAKICAoVGhlIGd1ZXN0IFRTQyAn
a2VlcHMgb24gcnVubmluZycgd2hlbiB0aGUgZ3Vlc3QgQ1BVIGlzIG5vdCAKICBydW5uaW5nLCB3
aGljaCBpcyB0aGUgc2FtZSB0aGluZyBhcyB0aGUgc2l0dWF0aW9uIGluIHdoaWNoCiAgYSByZWFs
IENQVSBpcyBpbiBsb3cgcG93ZXIvd2FpdGluZyBzdGF0ZSkKICAKICBIb3dldmVyIG5vdCBleHBv
c2luZyB0aGlzIGJpdCB0byB0aGUgZ3Vlc3QgZG9lc24ndCBjYXVzZSBtdWNoIGhhcm0sIHNpbmNl
IHRoZQogIGd1ZXN0IHVzdWFsbHkgZG9lc24ndCB1c2UgaWRsZSBzdGF0ZXMsIHRodXMgaXQgbmV2
ZXIgbWFya3MgdGhlIFRTQyAKICBhcyB1bnN0YWJsZSBkdWUgdG8gbGFjayBvZiB0aGlzIGJpdC4K
ICAodGhlIGV4Y2VwdGlvbiB0byB0aGF0IGlzIGNwdS1wbT1vbiB0aGluZywgd2hpY2ggaXMgVEJE
KQogIAogKiBYODZfRkVBVFVSRV9DT05TVEFOVF9UU0MKCiAgT24gcmVhbCBoYXJkd2FyZSB0aGlz
IGJpdCBpbmZvcm1zIHRoZSBrZXJuZWwgdGhhdCB0aGUgVFNDIGZyZXF1ZW5jeSBkb2Vzbid0CiAg
Y2hhbmdlIHdpdGggQ1BVIGZyZXF1ZW5jeSBjaGFuZ2VzLiBJZiBpdCBpcyBub3Qgc2V0LCBvbiBm
aXJzdCBjcHVmcmVxIHVwZGF0ZSwKICB0aGUgdHNjIGlzIG1hcmtlZCBhcyB1bnN0YWJsZS4KICBP
biByZWFsIGhhcmR3YXJlIHRoaXMgYml0IGlzIGFsc28gc2V0IGJ5ICdpbnZ0c2MnIENQVUlEIGJp
dCwgcGx1cyBzZXQgb24gZmV3CiAgb2xkZXIgaW50ZWwgbW9kZWxzIHdoaWNoIGxhY2sgaXQgYnV0
IHN0aWxsIGhhdmUgY29uc3RhbnQgVFNDLgogICAKICBJbiBhIFZNLCBvbmNlIGFnYWluIHRoZXJl
IGlzIG5vIGNwdWZyZXEgZHJpdmVyLCB0aHVzIHRoZSBsYWNrIG9mIHRoaXMgYml0IAogIGRvZXNu
J3QgY2F1c2UgbXVjaCBoYXJtLgogIAogIEhvd2V2ZXIgaWYgYSBWTSBpcyBtaWdyYXRlZCB0byBh
IGhvc3Qgd2l0aCBhIGRpZmZlcmVudCBDUFUgZnJlcXVlbmN5LAogIGFuZCBUU0Mgc2NhbGluZyBp
cyBub3Qgc3VwcG9ydGVkIHRoZW4gdGhlIGd1ZXN0IHdpbGwgc2VlIGEganVtcCBpbiB0aGUKICBm
cmVxdWVuY3kuCiAgCiAgVGhpcyBpcyB3aHkgcWVtdSBkb2Vzbid0IGVuYWJsZSAnaW52dHNjJyBi
eSBkZWZhdWx0LCBhbmQgYmxvY2tzIG1pZ3JhdGlvbgogIHdoZW4gZW5hYmxlZCwgdW5sZXNzIHlv
dSBhbHNvIHRlbGwgZXhwbGljaXRseSB3aGF0IGZyZXF1ZW5jeSB0aGUgZ3Vlc3TigJlzIFRTQwog
IHNob3VsZCBydW4gYXQgYW5kIGluIHRoaXMgY2FzZSBpdCB3aWxsIGF0dGVtcHQgdG8gc2NhbGUg
aG9zdCBUU0MgdG8gdGhpcyAKICB2YWx1ZSwgdXNpbmcgaGFyZHdhcmUgbWVhbnMgYW5kIEkgdGhp
bmsgcWVtdSB3aWxsIGZhaWwgdm0gc3RhcnQgCiAgaWYgaXQgZmFpbHMuCiAgCiogWDg2X0ZFQVRV
UkVfVFNDX1JFTElBQkxFCiAKICBUaGlzIGlzIGZlYXR1cmUgb25seSBmb3IgdmlydHVhbGl6YXRp
b24gKGFsdGhvdWdoIEkgaGF2ZSBzZWVuIHNvbWUgQXRvbQogIHNwZWNpZmljIGNvZGUgcGlnZ3li
YWNrIG9uIGl0KSwgYW5kIGl0IG1ha2VzIHRoZSBndWVzdCB0cnVzdCB0aGUgVFNDIG1vcmUKICAo
a2luZCBvZiAndHJ1c3QgdXMsIHlvdSBjYW4gY291bnQgb24gVFNDJykKICAKICBJdCBtYWtlcyB0
aGUgZ3Vlc3QgZG8gdHdvIHRoaW5ncy4KICAxLiBEaXNhYmxlIHRoZSBjbG9ja3NvdXJjZSB3YXRj
aGRvZyAod2hpY2ggaXMgYSBwZXJpb2RpYyBtZWNoYW5pc20sCiAgICAgYnkgd2hpY2ggdGhlIGtl
cm5lbCBjb21wYXJlcyBUU0Mgd2l0aCBvdGhlciBjbG9ja3NvdXJjZXMsCiAgICAgYW5kIGlmIGl0
IHNlZXMgc29tZXRoaW5nIGZpc2h5LCBpdCBtYXJrcyB0aGUgdHNjIGFzIHVuc3RhYmxlKQogICAg
IAogIDIuIERpc2FibGUgVFNDIHN5bmMgb24gbmV3IHZDUFUgaG90cGx1ZywgaW5zdGVhZCByZWx5
aW5nIG9uIGh5cGVydmlzb3IKICAgICB0byBzeW5jIGl0LgogICAgIChJTUhPIHdlIHNob3VsZCBz
ZXQgdGhpcyBmbGFnIGZvciBLVk0gYXMgd2VsbCkKCgoK


--=-DUQzlO94mllHXCRz4Pqm--


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A784677068
	for <lists+kvm@lfdr.de>; Sun, 22 Jan 2023 17:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjAVQKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 11:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjAVQKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 11:10:02 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9919821974;
        Sun, 22 Jan 2023 08:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674403801; x=1705939801;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=W1DMcmxxuPyhCSVP9BInb5PzO19g12QdLJPsrjS+ZQg=;
  b=nJNTr87R/aoHv3NUKVBhsXF3dYekfVMaP8uqnL9UP3fMNdVFUsG3MtLf
   gc9tMI/1XTtjXHwuoc5WJbyJImPh0wzmK8Pie4hWGcsYeWj6tvJt1jBjy
   Pt/JcBo39m1JYmdvSClocPvCb8Kgnfea21xKXUHaQNr9/sqJYWYoJB2hW
   0=;
X-IronPort-AV: E=Sophos;i="5.97,237,1669075200"; 
   d="scan'208";a="289193225"
Subject: Re: [PATCH RFC v7 24/64] crypto:ccp: Define the SEV-SNP commands
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2023 16:09:55 +0000
Received: from EX13D46EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id 9EE678114F;
        Sun, 22 Jan 2023 16:09:52 +0000 (UTC)
Received: from EX19D024EUA002.ant.amazon.com (10.252.50.224) by
 EX13D46EUA002.ant.amazon.com (10.43.165.177) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Sun, 22 Jan 2023 16:09:51 +0000
Received: from [192.168.14.18] (10.43.160.120) by
 EX19D024EUA002.ant.amazon.com (10.252.50.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Sun, 22 Jan 2023 16:09:38 +0000
Message-ID: <377e3bba-3948-908d-610d-d9961518498b@amazon.com>
Date:   Sun, 22 Jan 2023 18:09:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
To:     Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-25-michael.roth@amd.com>
Content-Language: en-US
From:   Sabin Rapan <sabrapan@amazon.com>
In-Reply-To: <20221214194056.161492-25-michael.roth@amd.com>
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D30UWB004.ant.amazon.com (10.43.161.51) To
 EX19D024EUA002.ant.amazon.com (10.252.50.224)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-13.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNC4xMi4yMDIyIDIxOjQwLCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4gRnJvbTogQnJpamVz
aCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPgo+IAo+ICsvKgo+ICsgKiBzdHJ1Y3Qgc2V2
X3VzZXJfZGF0YV9zbnBfY29uZmlnIC0gc3lzdGVtIHdpZGUgY29uZmlndXJhdGlvbiB2YWx1ZSBm
b3IgU05QLgo+ICsgKgo+ICsgKiBAcmVwb3J0ZWRfdGNiOiBUaGUgVENCIHZlcnNpb24gdG8gcmVw
b3J0IGluIHRoZSBndWVzdCBhdHRlc3RhdGlvbiByZXBvcnQuCj4gKyAqIEBtYXNrX2NoaXBfaWQ6
IEluZGljYXRlcyB0aGF0IHRoZSBDSElEX0lEIGZpZWxkIGluIHRoZSBhdHRlc3RhdGlvbiByZXBv
cnQKPiArICogd2lsbCBhbHdheXMgYmUgemVyby4KPiArICovCj4gK3N0cnVjdCBzZXZfdXNlcl9k
YXRhX3NucF9jb25maWcgewo+ICsgICAgICAgX191NjQgcmVwb3J0ZWRfdGNiOyAgICAgLyogSW4g
Ki8KPiArICAgICAgIF9fdTMyIG1hc2tfY2hpcF9pZDsgICAgIC8qIEluICovCj4gKyAgICAgICBf
X3U4IHJzdmRbNTJdOwo+ICt9IF9fcGFja2VkOwo+ICsKCkJhc2VkIG9uIHRhYmxlIDQ1IHNlY3Rp
b24gOC42LjEgaW4KaHR0cHM6Ly93d3cuYW1kLmNvbS9zeXN0ZW0vZmlsZXMvVGVjaERvY3MvNTY4
NjAucGRmIEkgdGhpbmsgdGhpcyBzaG91bGQgYmUgCgpzdHJ1Y3Qgc2V2X3VzZXJfZGF0YV9zbnBf
Y29uZmlnIHsKICAgICAgIF9fdTY0IHJlcG9ydGVkX3RjYjsgICAgIC8qIEluICovCiAgICAgICBf
X3UzMiBtYXNrX2NoaXBfaWQ6MTsgICAgIC8qIEluICovCiAgICAgICBfX3UzMiBtYXNrX2NoaXBf
a2V5OjE7ICAgICAvKiBJbiAqLwogICAgICAgX191MzIgcnN2ZDozMDsKICAgICAgIF9fdTggcnN2
ZDFbNTJdOwp9IF9fcGFja2VkOwoKCi0tClNhYmluLgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2Vu
dGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3Ry
ZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBS
ZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K


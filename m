Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA74F665C92
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 14:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbjAKNcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 08:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238380AbjAKNcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 08:32:13 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE891BEB9;
        Wed, 11 Jan 2023 05:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673443716; x=1704979716;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WCzp7M4ycosz0EMSJh4L4RaC5FrOhLeIurCLoHLODJg=;
  b=qFUBXMNLpabYD/VxcApwE6SwLA0I4gN4LHiA54ab7eJah6vuCnvvv8tr
   Cvb5E/5YXUH/UJzB+xs58zHGvNk9UxN7atkzkGykd8UV56n8CHg7ZNS8C
   FTiPPqDT2SXYzsa8ISuJsWUzLlyyBNlF7bEM0GS2wWjO98x6z4b9/5uK7
   A=;
X-IronPort-AV: E=Sophos;i="5.96,317,1665446400"; 
   d="scan'208";a="299087112"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 13:28:27 +0000
Received: from EX13D40EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id C9BBEA2673;
        Wed, 11 Jan 2023 13:28:15 +0000 (UTC)
Received: from EX19D024EUA002.ant.amazon.com (10.252.50.224) by
 EX13D40EUA001.ant.amazon.com (10.43.165.234) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 11 Jan 2023 13:28:14 +0000
Received: from [10.220.99.6] (10.43.161.114) by EX19D024EUA002.ant.amazon.com
 (10.252.50.224) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.7; Wed, 11 Jan
 2023 13:28:00 +0000
Message-ID: <cc2998c8-1d18-caa7-0421-584c08406847@amazon.com>
Date:   Wed, 11 Jan 2023 15:27:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH RFC v7 40/64] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Content-Language: en-US
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
 <20221214194056.161492-41-michael.roth@amd.com>
From:   Sabin Rapan <sabrapan@amazon.com>
In-Reply-To: <20221214194056.161492-41-michael.roth@amd.com>
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D49UWC004.ant.amazon.com (10.43.162.106) To
 EX19D024EUA002.ant.amazon.com (10.252.50.224)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNC4xMi4yMDIyIDIxOjQwLCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4gK3N0YXRpYyBpbnQg
c25wX2xhdW5jaF91cGRhdGVfdm1zYShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fc2V2X2Nt
ZCAqYXJncCkKPiArewo+ICsgICAgICAgc3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRvX2t2
bV9zdm0oa3ZtKS0+c2V2X2luZm87Cj4gKyAgICAgICBzdHJ1Y3Qgc2V2X2RhdGFfc25wX2xhdW5j
aF91cGRhdGUgZGF0YSA9IHt9Owo+ICsgICAgICAgaW50IGksIHJldDsKPiArCj4gKyAgICAgICBk
YXRhLmdjdHhfcGFkZHIgPSBfX3BzcF9wYShzZXYtPnNucF9jb250ZXh0KTsKPiArICAgICAgIGRh
dGEucGFnZV90eXBlID0gU05QX1BBR0VfVFlQRV9WTVNBOwo+ICsKPiArICAgICAgIGZvciAoaSA9
IDA7IGkgPCBrdm0tPmNyZWF0ZWRfdmNwdXM7IGkrKykgewoKU2hvdWxkIGJlIHJlcGxhY2VkIHdp
dGgga3ZtX2Zvcl9lYWNoX3ZjcHUoKSBhcyBpdCB3YXMgZG9uZSBmb3IKc2V2X2xhdW5jaF91cGRh
dGVfdm1zYSgpIGluIGMzNmIxNmQyOWYzYSAoIktWTTogU1ZNOiBVc2Ugb25saW5lX3ZjcHVzLApu
b3QgY3JlYXRlZF92Y3B1cywgdG8gaXRlcmF0ZSBvdmVyIHZDUFVzIikuClByZXZlbnRzIGFjY2Vz
c2luZyB1bmluaXRpYWxpemVkIGRhdGEgaW4gc3RydWN0IHZjcHVfc3ZtLgoKLS0KU2FiaW4uCgoK
CkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9m
ZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291
bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9u
IG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=


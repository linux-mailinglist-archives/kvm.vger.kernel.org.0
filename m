Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D557718FB8
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 02:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjFAAwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 20:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjFAAwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 20:52:06 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 17:52:05 PDT
Received: from esa2.hc3370-68.iphmx.com (esa2.hc3370-68.iphmx.com [216.71.145.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADA8119
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 17:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1685580725;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K4wnWrqHVQYbBVMzK/MGRQ7I3QfUxXVE7XMNBG1O1DM=;
  b=emm3Mfv8k17Mxay0Ts1oJZA+CoxfnbmXBcfpdBRwQMFlcybuWt9syi1/
   CixAMUoKXT4ZcG3xrpzDdFUlTt+nJq/cT8ddqG5krJ7K+eYGyBsZlYdq4
   mxqi6gZ4H+V0O2heuKstLHm/X9i7y/HdDgOoIbIOH5Td9uPAbOxgVKlih
   w=;
X-IronPort-RemoteIP: 104.47.73.47
X-IronPort-MID: 111037554
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:tldwAq7q/KNIfu8/AsKW1AxRtA/HchMFZxGqfqrLsTDasY5as4F+v
 mUZUGDSOP3fN2r0fdtxaN7g8kwD7JKHzYU3GgM5rChhHi5G8cbLO4+Ufxz6V8+wwm8vb2o8t
 plDNYOQRCwQZiWBzvt4GuG59RGQ7YnRGvynTraCYnsrLeNdYH9JoQp5nOIkiZJfj9G8Agec0
 fv/uMSaM1K+s9JOGjt8B5mr9lU35JwehBtC5gZlPa0Q5QeF/5UoJMl3yZ+ZfiOQrrZ8RoZWd
 86bpJml82XQ+QsaC9/Nut4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5iXBYoUm9Fii3hojxE4
 I4lWapc6+seFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpdFLjoH4EweZOUlFuhL7W5m9
 tVJByEiZxe/xOvrm+/lV8VFoO8HM5y+VG8fkikIITDxK98DGcyGb4CUoNhS0XE3m9xEGuvYa
 4wBcz1zYR/cYhpJfFAKFJY5m+TujX76G9FagAvN+exrvC6Ml0otj9ABM/KMEjCObexTklyVu
 STt+GPhDwtBHNee1SCE4jSngeqncSbTAdtLTObnq6M26LGV7kBPCERLS3i4mOXjsQnvYI94M
 2wkyhN7+MDe82TuFLERRSaQomaDvxsWXNd4EOAg7gyJjK3O7G6xBG8CZjhcdNUgtd9wTjsvv
 neSktrvBzdHv7qSRnaQsLyTqFuaISISK30DYy4sVwYJ49D/5oo0i3rnUtlnAIaxj9voBSv3x
 TGa6iQz750WjMgE0I2h8FzHii7qrZ/MJiY//i3eWmOo6FM/aIPNT4Ch91Wd7f9GN4ufZl2Au
 mUU3cmY8O0KS5qKkUSlULVTNLKk/fCINHvbm1EHN5k5/hy/6mKkZ8Zb5zQWDF9kLsseaxfoZ
 kHJsA9c7ZMVO2GlBYdvap24DYIp0K3pD5LqS+jIZ/JKY55sZEmG+j1jYQib2GWFuEQll6AyP
 dGAd8ugAXEcIaBmyiemAeYbzbIvgCs5wAv7Ro7+5wqo3KDYZ3OPT7oBdlyUYYgR6KKCvRWQ8
 NtFMcaO4wtQXfe4YSTN94MXa1cQIhAG6YversVWcquPJ1RgEWR5V/vJm+t9JMpigrhfkfrO8
 jelQEhExVHjhHrBbwKXdnRkb7CpVpF6xZ4mARER0Z+T8yBLSe6SAG03LvPboZFPGDRf8MNJ
IronPort-HdrOrdr: A9a23:78avWqEPdHkOjsNOpLqEZ8eALOsnbusQ8zAXPo5KKCC9Ffbo8/
 xG/c5rsCMc7Qx6ZJhOo7290cW7LU81G/ZOkPMs1PSZLXLbUFLBFvAe0WKa+UydJ8SdzI5gPN
 ZbAspD4YbLfD9HZK/BiWHSLz9H+ra6GcuT9ITjJhlWIz2CQpsQkDtRO0K0ElBWWAIDPpYwDp
 yaj/A33waISDA4btmbGnJAZOTIp8TKmJX6CCR2fiIP2U2hjS6I9LW/KBST3g4fXzRThZ8u/H
 PIiRaR3NTcj9iLjjHdyk7O5NBtlNztxsArPr3rtvQo
X-Talos-CUID: 9a23:g3VOam14RNCF/Eey1mK9bLxfGel0XWzyxXDsYEblUjs3VZG8b3S05/Yx
X-Talos-MUID: 9a23:q0//jAgkAMY7dhs59V2E2MMpGJtouvmwK0M0jc89/Ji/aAtoGwettWHi
X-IronPort-AV: E=Sophos;i="6.00,207,1681185600"; 
   d="scan'208";a="111037554"
Received: from mail-dm6nam04lp2047.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.47])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2023 20:51:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVFo505WVQ3OgD88T6BU1ILN8ylAbAqs0DQf/gmtl+KsxoaQ5FuRbYFlz6cgYUanejf325JcrMiiNVJ+6Icj11B9wSPHgTbJBXsvOaoUGOmqnlXtl+j4/WsjBz3LE684TjiS8jf16xGXO5apF41XNwFtZs8T09jfraticeFD6G5ioobeXP3nPo0GIPQKbI7fh12gO/ZNXigf5ia4x3zREF2CDsAAoUHzdxd00dn93P3nJ7Sy7JPUaVNbnMMCn8BUOI9saqi+d5w6yvUWZ169z+6xEto8QDatwO6KhvvbpyATJsNBeiXELPzDK0+WUHudl2QvSnZ6cL43rk14dLW/Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XY1f4RCWf1SS42EHPa3FaAHxeIHDxO8ozcEhzre7r14=;
 b=WTEZ6U4w9s5d/YPOMykzCWNJ0wppnIkGY1WdXc6Mvy//e/aUrAxcQ0ArBAQCTGpwYXOUvrAEERktT2q+A8cdJi/fwcQdPoFdBBPX1j2HdHN5o4IN45uKtKIlEPkOvyNDVgFMd+duXEhi9nL1tdby8WSLVfehfoR3GIA6I/xOo/PHX/Ub1cTXT8zeh131uKkh9LvkkcUoZE3qGwsw5qhQJJOy6OSd/b9iAweKZ29NSfhepuejs82c0D345Y2wur6HFUxT+0ntLJFZlviQHEMNfKdAU2NXmYabAhsFY8ADULtrbQUtNgkcBrc3mpVsTdDr4srCNO/2rwfy/qh0JCatqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XY1f4RCWf1SS42EHPa3FaAHxeIHDxO8ozcEhzre7r14=;
 b=dtDtJqLqLh5WkhNAGEyGAeqzEesdpjBR8HWLGnOgZOCMqdsvyKVkPstkq4V+RvU9OX5gsMP8dst1AgCb83XR2lPZAZvlPw3cN/YiuF7rL00JprMz4Ye2pusUddguuQcb5ZglIqWoN5Ufr33WDbDUsjFGv2f/Lf+9M2Pm1DkPlTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by PH7PR03MB7487.namprd03.prod.outlook.com (2603:10b6:510:2ea::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 00:50:56 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::10bb:98bc:e36d:36ab]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::10bb:98bc:e36d:36ab%3]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 00:50:55 +0000
Message-ID: <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
Date:   Thu, 1 Jun 2023 01:50:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Content-Language: en-GB
To:     Josh Poimboeuf <jpoimboe@kernel.org>, Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
In-Reply-To: <20230601004202.63yulqs73kuh3ep6@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0118.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::15) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|PH7PR03MB7487:EE_
X-MS-Office365-Filtering-Correlation-Id: 748df153-be0e-48b6-1754-08db623a41ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WMwFIoxeD+A5V285MSjMCclCltqDEyMWRv6pPfglkmsWbm6gNI6Rv6nUMPd80TbycEx6oTKNFAEzqcTD7KY7gLTOBtmFtWZuWWOAdal7/pru7PpwSYFZEIILG7VGhqPiPTjlzXg+ZnJwtUtzGuAfUrm24eZNh/6BU7uo4GiI3i3wUtbCt6h9z/i07aMq01JUnsa2vwgpFAK99qMV/GEwhmLPyKof+X8sAFrqjnFnhpacUA48nLkzrNlDVCLb2kPdfeiUO1cUC9QBbJ/JMiOF2Azyq/NZmgkLArSCp0JcV/jIacdQoRaDbZq61n2Y8KtCULY2AsTe0AE/Ak7wZrZKNEW4KxWnuGye6JnGCmWxEIPkAoMf95Rmyg+eIgJjBbKx5DAHQcxQQIdTbSwQdtBHiNW1Qc7dAcIrxnXNgDscpm9RvX+JW4cpItFAw9tgbThw+PQRo/dz9rK3uHVQ3IoDIPeNo3O+Mb2DlVTuF3EgPTtty5q9JUXdFuR6jSe17bVkOfmGmq4nrODjSuZVn6PEimLiVyLlY1AxJ9PvmE2Je9xZ2VObHi8eMbAdaUo6MpMGxy6VJJVIe4m+NiyvqQ7xRETUzH+F+48MkzOYKG6pV/EZ4h0yJDlZIrm/q+r/1WBjjM9naPeQ85smoxUwM8psow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199021)(26005)(36756003)(53546011)(6506007)(6512007)(7416002)(186003)(82960400001)(38100700002)(478600001)(66946007)(4744005)(2906002)(66476007)(66556008)(110136005)(4326008)(31686004)(54906003)(316002)(6666004)(5660300002)(6486002)(8676002)(31696002)(41300700001)(2616005)(8936002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUVROGZSK1h2RjQ1dVZaSGVxaGpUWEZDZlZSNzVHaldNbUFYa0lFNVJJeXJ5?=
 =?utf-8?B?K3ZLYWM2V29VVUkwckFqVnJ6RGF1Z0l4eVBTc0dFaVhUcmdwcFM2dWlEM2o5?=
 =?utf-8?B?SDFQSFoveFM2RUtCZWFaN1pGRXZkUUtOdFl3Wngrb256eTR0YzVQZGJhbVl3?=
 =?utf-8?B?MlcyenI5aTZGYXJrTFhQcWIra3c2RlNqelV6Y2RLTzVYYkswMGlzWUtHWnJt?=
 =?utf-8?B?QkU0U0xmS2lkN0xtQXdrc21Lek0ya3JVS2gwNFdPbzJIVldOWWZRcGYyL1di?=
 =?utf-8?B?NTlwWkRZZVNoN1JkbGE2dXorZzBnT3lOYUlncGVKbGd2L2VPK2RKTWN2SXhR?=
 =?utf-8?B?YnVQZWpjb0NvYTQyRWZtQjFrUC9aV21wYTZtWEJpWHllaGR0aDhRSXZya2c3?=
 =?utf-8?B?WFdHeEh0YkRwdnRNWndPaUFwMnZ0T3RNelUxSVB2UGtDeVFHR2lQYjRtOGpU?=
 =?utf-8?B?a3NvNk5TZGZXUm1YbHQ5cDBpUURoMmg0S3o1Z0ZVd254R0pEc0RwTURBNXlL?=
 =?utf-8?B?bk42dHhnaTdkSmUrdHA5dHZmSDRHM1hjK1hHaFA0NXpXbms0ODdFWjVrVFla?=
 =?utf-8?B?ekg3ejFSVU5xaC9lTnF1bFo0M0VWdlMzcDJxdzFwQ0hoVkhvczVUbEtTRjlp?=
 =?utf-8?B?alNMMlBEUUJaZTR4aUZ1MThiNnRmcDBlZldPTHZEU1YyaTAyOUdubThQSVRZ?=
 =?utf-8?B?YzFnVG9jU3NTckEyN1NVLyt2c2VnQ1ZwRVRkME44V2N3bHZSbEFkOUcyR0wy?=
 =?utf-8?B?dUg1YTQ4cjM1blZUV2cyZnM5K2QvcWxMQUVPRHlLZjRDNFc5czFIcFlBVHYx?=
 =?utf-8?B?d3JJMG14R0hFa3pKTDFuUExBY2crRm1kbzg0M0Y3SFhLa2FpL1p4UytudjFM?=
 =?utf-8?B?SzRYWm5nT2FTZEZMUUxlTHNWV3dsVEU1S2FOWEFJbDBJVmtrcy93bVRzcHV1?=
 =?utf-8?B?ZDhKcmo4T0ZiUnVVcDRDMFRaUVBtekZoSTZ3WlZJU1NTRHVsVlVEZU9YZm14?=
 =?utf-8?B?ZUU4cVdpTDhGZHRlbGp6YmZxMFBHUUplTjNIVG1xSi9KUURNaHZlYUh6ZExG?=
 =?utf-8?B?ZzJlQkNvVXdFZ1JRRXhKTzFGRVBzVVYzbVpDZDJpdjZBWkRiTnNaL3pTQnUr?=
 =?utf-8?B?T0YzeEQza0EyM1paTlJqeDl0blAwNGFOdG42NG1taVpDWGhkQno2dGdkTXRt?=
 =?utf-8?B?SVJzclZNZnZ0UUpIZjZYSnhLZnQwVTVHYlVUanE1dUlBcms2c2pib0w2ZFJx?=
 =?utf-8?B?VDI3R2p2Nm8rWlArMzk5bnU5aUtsR1VFNXFockk0djZKSEQ0NERybm53cTk4?=
 =?utf-8?B?aS93MDIvbEhxb3NYSnNMQjRuYlpaSGZvMFhNcXdWTGh3VHpKUnBlWVl1ei9n?=
 =?utf-8?B?cFdiVEc3NFE3ak9RZWxXTExUdmpuY1B1T1ZuUlE3NkRhN0JTeU1ISlF3dHdU?=
 =?utf-8?B?MHE0UjBKMHVDczB6SEJJcXBjNTRqWnVJaUZJaTV0dTA5bzRwVC9qdHEvUzFM?=
 =?utf-8?B?dldzWW1wR2FEK0N0VTRQMzMxY0d2dm1rN3QyU2V4OVRKYmpQL1RzWXA2ZTRC?=
 =?utf-8?B?SFE0blNOSGhzSmx6d2N4ZEQ2R25ST1hrTWNxZUw1SVVUaUUwdXJhM3RDVVFY?=
 =?utf-8?B?N1F5VU9NL2NjeVJ1VGdNbDRhM0VKZ01kVkNmQmZjOEkyU1JYanREQ3FxT1cy?=
 =?utf-8?B?R0JLaVFDR3c3MEdyUDRudkhmbHB0eFNPbVl5N1JpVEh3dDVzQ3JEYWN6ODFR?=
 =?utf-8?B?QzhSM1BKWWtMcnJnQWx5NkVZaUtkYnJRWkgxRFRrNlBNeThvKzdRTkxBdmlv?=
 =?utf-8?B?V3hYcXo3b3VCcEdMbnd5WmZ5cFRobXozNTlGVlEyZ3ZCTTJUeGQ3Z2hOWW1l?=
 =?utf-8?B?WG1SQXMwcTdJVVlSM3pJcHVLN1hwWmQxa1JsaENENkxXWG00U0pRMWVSZDFM?=
 =?utf-8?B?d0IwalhKV2VFZXBaczBnYjZQUGE1UUxBSllLQ1M4SXloRlNRMGFtMHMwbXBN?=
 =?utf-8?B?a1dFa1Q1Qmc4K0JabkhsRHBMYWFMeUl2N1RRc1IrQTVWTnhZaVhGN1p5TXMw?=
 =?utf-8?B?b2RsNXpTTU1OcVlFOG14dTJ5VzBrSDZqQUNoVVNWZThqdHp2WldjMEtjNm1I?=
 =?utf-8?B?N0UwbHlYNWtYbm5NQy9aTFNidXErbjhiSUlZSzE3MG94K3NuYnUzNGkrZTA1?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZytrbEw4L3lRQmlVcW83VG82SnZ6Ui9wZEdSeHVEVGliTHZycWpDUk5leDJN?=
 =?utf-8?B?R202L2NSbmlPdnhGbHY1OUcvakJFSThyditzMG9ZUlZoczhlSVplTmxjWjkx?=
 =?utf-8?B?dDcxNXV0SlpOQmpQSzRQZ0NMWXhzN3FBY0E3R29mczBFNVpDOUNmV2VGUTdz?=
 =?utf-8?B?Y2hlMjROdU4xbFJVTDJsNkQ3VjRsb0dYVTN4NmdIcEw3eVZHOEppOXdWU1Vh?=
 =?utf-8?B?T3ZFU25zeG4vY3VxcmpleFVWdDIxSjZKanhmeHFtWnRNaVdLMVRIQWRYb2lW?=
 =?utf-8?B?K3piUVJYWjk4ZnhZb3QrUnhKS3lRSzFHWEhlT2xkb2MyWi9SbE5QOEdKSFVI?=
 =?utf-8?B?YnNWc29jbnBzVll2Q2hiczNsZ0RlQlIvNEtmZmwvQ0pSMGF3aCtCQWFQVHhT?=
 =?utf-8?B?Q1NQYlFrZmtRSUhHUlUwUFlZcE1QR0VZY0hWb0JaQ2lDdmh4Zjhteks3Q0Zq?=
 =?utf-8?B?bkZSWCs0SWtQK0dXZS9rcXBLL1BrYjN6cmVoekdDUlVjOVY1dlZ2a2R3QXkr?=
 =?utf-8?B?N04zN1lnVkQyRmhGR0hHMEtVL3VTSzlwTjZrczUySElpQVZCSjNPRmpnejVE?=
 =?utf-8?B?eDJKZ3MrYjB3bVJqR2tGKzU2RTdzS2g3NnBsSExJaW9BbmM3bjJkTUZ1cVpa?=
 =?utf-8?B?MmUwNkhJNmN6SGU3ZW9vZGl4UTVpZngxUGl6U0VxSDBuMDE1VjVDbE5DQjlw?=
 =?utf-8?B?cmcyYXJjMDlZQ211QWZTcXZ0ZHBtTnZsazhhcWtFQkR2UUxSWjRQTmhCODhL?=
 =?utf-8?B?b014OFFHWWkvRjM4d1NjTFg4b2RqK1lPWHhWNEUxREFVYkFCbTBaQTd0YjZL?=
 =?utf-8?B?RjRGdmx0Z1ViRk8zcXBtNDFPMSs5cGpKNzJGV1JGMkFLNU9vMmU4TnE1ckZk?=
 =?utf-8?B?QWkvdi9lQjIrUzl2TTRXa3dYL3VCT0haamJuS216Y1NpSCtVTU56M1dVV3I2?=
 =?utf-8?B?TG5xalk4Ym9IeEZvVjdUZVFqeW9sTGF3U2RrQ1pRb2pjbFZyYm1HY3lRZStC?=
 =?utf-8?B?VTRTTndpZnNCbUhPcDBOZGJFL3d0eDNFdmwzcCtjRm1lZW1jS3VwTW5rWnJ5?=
 =?utf-8?B?Zk1PWDJRcXhublhXNmFIV2Nza2NsTHNqVlFxd1pCZVF4bmUvTzh0aFB4SmFx?=
 =?utf-8?B?aFd1MHNPQ3FzK2ZFeXFRY0tFS0E0Vk5jMHE1cmlKOHA1VWRRazQweWdFa1c0?=
 =?utf-8?B?ekFqQUMybkNBcTFraFN5MHpwSWNMVVlBbUwrZjZwK05Td2haL3pKNWc5eHhH?=
 =?utf-8?B?MWZiMHl5UC9FN1JpN1dwTjlrUmNucEpKNHZHMnlKWFlsemUzWlZXU2kwWThq?=
 =?utf-8?B?cEt3YUNBbCtBWnI0NFZ5aDFZa2dBNUZudFNSblBmRElyVWk0M0VrOWkyNlpV?=
 =?utf-8?Q?0zTwFPNdY/E1+TTN4Y4ymiSZmTrcPSE4=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748df153-be0e-48b6-1754-08db623a41ae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 00:50:55.5362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uUo+qUJA9ScptaNdPu3R6Kqb4QmE6hsFmml+0ZN2WiIaZ4SnZiaqxMDdLxW2fJ0S5kF4xF8tCTOB1gEwPALs8WRC+j3VbpMGhK+HdhNiie4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR03MB7487
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/06/2023 1:42 am, Josh Poimboeuf wrote:
> So each LFENCE has a distinct purpose.  That said, there are no indirect
> branches or unbalanced RETs between them.

How lucky are you feeling?

You're in C at this point, which means the compiler could have emitted a
call to mem{cpy,cmp}() in place of a simple assignment/comparison.

~Andrew

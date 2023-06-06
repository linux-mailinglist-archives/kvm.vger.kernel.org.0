Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C1B723401
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 02:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjFFAWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 20:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjFFAWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 20:22:12 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Jun 2023 17:22:09 PDT
Received: from esa6.hc3370-68.iphmx.com (esa6.hc3370-68.iphmx.com [216.71.155.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5CEE6
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 17:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1686010929;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CKlk6VcDHKbwpJnZ4TQqjxQ9cJAlk88MJCvCpkW9WNU=;
  b=IvIFeeNwp4K8yeZGs0nIKd0lY97Dqzs5cfUNB6gNtPsa4mbCb/JggOZT
   gvi6GAtLD7UNoXJF0MLqFPY6pGXQuyv99Gj/uadiND0wJ+B2lZBXE06ya
   I+uP3h4lx4SZNGAmuxrZ/j3jbSDXHP1JbmuHDMu+nuZA4zDqnof6ui5ey
   I=;
X-IronPort-RemoteIP: 104.47.58.104
X-IronPort-MID: 111016110
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:uXbJn6reWpZm1VMx5o2rX6nITfxeBmIuZRIvgKrLsJaIsI4StFCzt
 garIBmOPayDZ2X8e95yadi38kIPuMLQnN9rHVRkpH1gE3sU95uZCYyVIHmrMnLJJKUvbq7FA
 +Y2MYCccZ9uHhcwgj/3b9ANeFEljfngqoLUUbKCYWYpA1c/Ek/NsDo788YhmIlknNOlNA2Ev
 NL2sqX3NUSsnjV5KQr40YrawP9UlKq04GtwUmAWP6gR5weAzyRNVfrzGInqR5fGatgMdgKFb
 76rIIGRpgvx4xorA9W5pbf3GmVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0MC+7vw6hjdFpo
 OihgLTrIesf0g8gr8xGO/VQO3kW0aSrY9YrK1Dn2SCY5xWun3cBX5yCpaz5VGEV0r8fPI1Ay
 RAXACoiaxbZjP/p+YOiZuV03Z1kMujIYapK7xmMzRmBZRonabbqZvySoPN9gnI3jM0IGuvCb
 c0EbzYpdA7HfxBEJlYQDtQ5gfusgX78NTZfrTp5p4JuuzSVkFM3jeiraYKJEjCJbZw9ckKwj
 2TK5WnmRDodM8SS02Gt+XOwnO7f2yj8Xer+EZXhr6cy2QPKnzR75Bs+cFKyucbpiw2HW88OM
 U804hF1gIUz6xn+JjX6d1jiyJKehTYeQ91RFuc95SmOx7DS7gLfAXILJhZDb9oOstIqTDorx
 hmCmNaBLSRmr7STD3GA876O6zyvITQcBWsDYzIUCwoD/9Tn5oo0i3rnVdtqFqy+ptLyHj70z
 naBqy1Wr60ZisgZ1qO61UrKjzKlut7CSQtdzhnYWnKN6gJ/eZK/YIqp+R7X4J5oKYefQV6pp
 nUIm8GCqusJCPmlnjSlSeEMEbf5ofqIWBXQiEBiWZko8S+g/VanfIZN8Hd/IltkNoAPfjqBS
 F+D5ytS6YVVMX/sarV4C6qxE80C37n8Es6jXffRBvJWb4R8bh2v/Sdgf0ec0mnh1k82nskXN
 Z6dcMuoS20cBKhryzyeQ+YbzK9txyYiyGeVTpf+pzykz7+2enGYU/EGPUGIY+R/67mLyC3R8
 tBCJ46Jxg9ZXenWfCba68gQIEoMIHx9Aor5w/G7bcaGKwtiXW0kVfnYxOp5f5Q/xvwJ0ODV4
 nu6R0lUjkLlgmHKIhmLbXYlb67zWZF4rjQwOilE0UuU5kXPqL2HtM83H6bbt5F+nAC/5ZaYl
 8U4Rvg=
IronPort-HdrOrdr: A9a23:3fQik6OtjoYF48BcTgWjsMiBIKoaSvp037BK7S1MoH1uA6mlfq
 WV9sjzuiWatN98Yh8dcLO7Scu9qBHnlaKdiLN5VduftWHd01dAR7sSjrcKrQeAJ8X/nNQtr5
 uJccJFeaDN5Y4Rt7eH3OG6eexQv+Vu6MqT9IPjJ+8Gd3ATV0lnhT0JbTqzIwlNayRtI4E2L5
 aY7tovnUvaRZxGBv7LYEXsRoL41qT2qK4=
X-Talos-CUID: 9a23:GGiAum+TJ9IBscVywTmVv1Q7H8Z/eWCC9UbJD0OgUj8uVpy2FHbFrQ==
X-Talos-MUID: 9a23:d7rF9AQvzfluXOXqRXTJjTh6C5dpoJ2uFREXkrUegJKpGC1vbmI=
X-IronPort-AV: E=Sophos;i="6.00,218,1681185600"; 
   d="scan'208";a="111016110"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Jun 2023 20:21:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjDTF+ySYvlTNhPNMNkCnmaA0jaye3hwon5EjL2g1q8rj/KqSDyP4guDqR5Z6NrLaDhZ/oOIyHtj24C0wAt18nIC5OtTjVyWipE6hMCD0uLo4ZRvXrFHbyfMIswGYTib8H7zMq4lHvPT0/bcqXtCwv+wLe3/unELF5nIKvnGgdM3p9B19BVQRkayLhKatvS5XG8A1vNlsvKgnV2HHvInPg38rAtnJ4NHo4uFz6ZOfxWYzNOTYJNpdD5GsfbwCyOs+Pxr8piUVyOZ1r3ZOZHY6pfxJEIyW9WmXB2dHVJFQmMwm7xpPZxIhB2C/VcB0k9xJSUVfPwYECnmevQI7tm5BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7rI1PadIzJ2iPaYGqHOQBLOrK66bg0YMa367Bh7qrg=;
 b=lo5ExEZ0i14IBlVtOOWQuOOgvZ8mIPy2xrMVLUzsrYjjfgHUMd8MM2l7QsW7Y4axv0QuxDvlRRrVb+PdLvpd0JKIAyoGbyq2MqLpWXxm3G8Qz9GF+iWs14NECe4A5ukOFXqXd97+Pi3Lgm0MbqidEd7Ph8IpwjI3SOtC6X76ERC1e4NTaWtqIJFp8F6yQc6CUaxrNkF9lGoLvxjGl6spTTbVYpB76OLoHHWOdg62RGd+DedIPj10fXsXmCm05CUf9tR50KLFoKmFJrEm/MMqyDMDESvTCJbex8uWk6sTxb50yprEJ0siJVEgUChOcNkJjvGt1os6vi5CyrNIrg7Tow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7rI1PadIzJ2iPaYGqHOQBLOrK66bg0YMa367Bh7qrg=;
 b=Nk9OjRU7lm6aPk6szc/fee7FfLaU3qMeZIuu3ErAK0fV6CK410iDYg2fJ/4PImmWdFJxGoGvu3bB8iY1sv3JWiY4FrLlyoxDPdWqNRhO5Il/pe2IP1JIanaXgROKuIKniteIwEVMlRWcrTCdycQhPYWMe7BMvqGNAvfEgE9NkVA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BN7PR03MB3618.namprd03.prod.outlook.com (2603:10b6:406:c3::27)
 by BY5PR03MB5169.namprd03.prod.outlook.com (2603:10b6:a03:219::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 00:20:59 +0000
Received: from BN7PR03MB3618.namprd03.prod.outlook.com
 ([fe80::7ebd:898:4cb0:7514]) by BN7PR03MB3618.namprd03.prod.outlook.com
 ([fe80::7ebd:898:4cb0:7514%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 00:20:58 +0000
Message-ID: <790725a7-cde8-addb-c2e4-91827f70215e@citrix.com>
Date:   Tue, 6 Jun 2023 01:20:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Content-Language: en-GB
To:     Josh Poimboeuf <jpoimboe@kernel.org>, Jon Kohler <jon@nutanix.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
 <20230601042345.52s5337uz62p6aow@treble>
 <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
 <20230605163552.hi5kvh5wijegmus6@treble>
In-Reply-To: <20230605163552.hi5kvh5wijegmus6@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO0P123CA0002.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::13) To BN7PR03MB3618.namprd03.prod.outlook.com
 (2603:10b6:406:c3::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR03MB3618:EE_|BY5PR03MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 27262706-e392-480b-6aaa-08db6623e6bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXPRoq7SzjexE8U5AZkHFQxJG9zIz89rYKQHWyzHaP9h5o9Y/iFpK/lbCbLoAsP0fZuLxb8vX2XdIcsP0pX9JTheIqzqO3+XiMRXO6lUsL6I7QyHE0PV6RhS+ydc8UKeI7z9THkH+jUTxYk90zok/jUz74vMgKpfL2E3ghy/ULFQWMQwmAuwNjfzkWtWi0sXHKV8LtKdsDPsfJebL/1WB9HFkDcojo+3ry583y7JwsIwLWYTEjZ40+CCmWuFX7rK7aG6JprD+anCgiLpebqcg7APZWyS2zPMMntudDgWjCjult6p9n2bwrh9o33mjqkeTBpZ87Sf6thZ4L0qQsxWGHSlqB3cdKEX7E3TLEyKmsdzGn5pqT46M5c1oNMYwjYLPL/UqJ3mm0dmY1452/wrIeVNoAUOYfgc7510hF7t9bfqXcf/DouKzU146D4Zhu/zVw1he3sEb5Arn73WDlOPbG7gamoaCEgkMV5PxfxPqA2Z3Ze/gPQkoMbcPgnKCRaXdAsiXz5bg2AbLoQx2oNsjDnihDJ+DYN2zA+HAu7Pcm2UZF1xSShPfDrC4MWhkKn8fHCmH58dAc9Y1/h9fB+22iXY7RvvdN3r+ZSPLIdKqnNmjiDVRvBW/Z1ebsz36sQkbxhDXcjuY4VghEvzpffdlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR03MB3618.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(6512007)(26005)(2616005)(53546011)(6506007)(316002)(83380400001)(66556008)(4326008)(31686004)(66946007)(66476007)(966005)(6486002)(6666004)(186003)(478600001)(31696002)(54906003)(36756003)(110136005)(2906002)(5660300002)(8936002)(8676002)(82960400001)(86362001)(7416002)(41300700001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mm00dnFwcS9BMHd3Vy9jcWRzMDIyN0ZFUEdjNE1PbUpESDFXNFNMdFNRbVlq?=
 =?utf-8?B?L1N4Vm1OUzYyOFN3bTY0NXljRGtpRnZnakhvZExydW1RQ1prTkRJWHJlSDJp?=
 =?utf-8?B?eHUrMlhKTFQ5OVRZeVFxbHMvbi96SmNHU0NlcDJOakpQMVArb1BmMEdKYWhS?=
 =?utf-8?B?UHNHV1c3L0duc3FrVXhFa1NwUkwwRDFkaWpBRk1DL2EvRE1QUlFVcDRIU2VS?=
 =?utf-8?B?amlkUXlVdjNKZHJCUVVPdHVCQTdWUVZRdVJUZVc1TExWTmtLR2d5UTJVUXlR?=
 =?utf-8?B?akFCTnZucUFJL0RzK2thamdjdWZ5bVMxNHRCMzVjMUhkNTg0TlZkSlNEUFhU?=
 =?utf-8?B?OWQ0UFVrYnNDMFJZSGQvNTFQRms5NFMyM2ljaFNUVDRIWjlwbW9PSDhkRFJa?=
 =?utf-8?B?UVZIUGY1S0s3b0d1ZTJ4VXRRK2tYWWNKUXd2b1FQNFJQVGY1WG8wc3F3SVhZ?=
 =?utf-8?B?ZTZtdUtmbzh0OEZjVzdzZDdOS3YrMDBTNDc1YTlZR1JtRG83ZzRMSTl3YmtH?=
 =?utf-8?B?blBMbzJLcS9KM1JDdVFTOW4rMFpsZENTbVlKVmRZVXRRR3JGMjFnL1JOdUxq?=
 =?utf-8?B?TEx5clB5UGprMm5XNGtiL3pGQnp4cjMzQXNULyt4UG81Vlg2VlA2K2RQMUV0?=
 =?utf-8?B?TVRJOVJrQ0twL1N1VWx1eDFzTDN1eldFVTV3RGRxQlRmdFlYYjNsdy9lOU5p?=
 =?utf-8?B?QmlMZkFBc0tOVlJNZzVKdHdURCtzeU1wQ3NTdForVmVTU1hvV0RqL2dmKzBY?=
 =?utf-8?B?bHFycFhrWk9XZFVHNnVDZmZlVG1lMmh0SEpEc2liaGlZUFNSbUhrN25zUkJ3?=
 =?utf-8?B?Y2Vod0N4Z3hyNWhCVjcyZXgxemcrUHp4L3VVWnJXcFZQNThEUzhlWUt1UlBp?=
 =?utf-8?B?MThZb3NpaGNZbHQyWXltM3pmajJJU2x1VTVFdkVFcXBsendXZ1ZSOWNPQjFG?=
 =?utf-8?B?cFpFNzBpejhiMkdVOHBiREtPRDhoY0tzeXR5ZDJYREZhZlBFUHgvZ0Z0d21J?=
 =?utf-8?B?Q0o5dmF6anJWcDVOVFBJUlJHTFd4L0tlR2FORE5OeEhrQ3B1QnR4OTJQNCs4?=
 =?utf-8?B?QVdYQkFnMmQrUjlnNnBraS9IV1EyRTdVYnpCa1BPcUZrbFNLSkN3NDdJTHM0?=
 =?utf-8?B?dngvbVRDT3lIaVhHZ1JoTGZlVDhKcElKL1pWY0hGSFJpaS9pZnlPWUxYL09R?=
 =?utf-8?B?OWM3eVZHNW9Na2F0aU5TaExVRDhZdHBUVEJLY1Y2cHovVzhnK2hReHRTUzhN?=
 =?utf-8?B?eXJ1aWZHbGVJQWFOOWh4OTQ4YVhiRURxZlR4dkdwSE9qSW9kRXVNdkh2bW8v?=
 =?utf-8?B?MXkybDRzVURoQ010TDB1WGwyWlVGYnhDclBwWFFRNjZQWXcrcEhrMjJtWUo2?=
 =?utf-8?B?UEdYazNWZnp4alR1RW1HWWIzY3MyR1dmL2dBSlF2bDJqS05MaS85cDhYWnhY?=
 =?utf-8?B?NkxuZEZxSlRxVjlWV00wSmUyLzlMZjlzNElKRWRBdVphT21yNG80a0Fhdkl5?=
 =?utf-8?B?Z09RYyt3UmQxUU1sY3NBTVBzQy9rUXZkSy9KazdsbFJjLzB3K29XM1JaNGdR?=
 =?utf-8?B?TEx0enU4SlN6OFhLSWhyOWgzL0dTVEJVUEsreUQ5dXFNT2l3MlhOZ1FraWtT?=
 =?utf-8?B?T0xIck5LSG11bHlsQjZORlZEdXEwbXBPS0NaTmxrWS9xVDNndVRmLzRJQ3Zs?=
 =?utf-8?B?T0dBblRTaDFLVlNvSE43Wk00VVQxeE80SkRkL0pVWnZ3dUhCS3dyRVowZVRl?=
 =?utf-8?B?VmJoNjJIQ1c2bXVjYmp6VjFNUW4vQ1gvVVZib00vSTNXQ21ITUtOcWMrcG5m?=
 =?utf-8?B?T29KMEU0aklob1pMWWpNV0k2OEtRNTJYTkZEWmhSeEhWM2dHcXpKODk5TVlw?=
 =?utf-8?B?Qk53UHNWRmRlaW93czM5ZUtBejQxZ1IxT0R4aFl5REUyRFY1K0pTR3huQVBo?=
 =?utf-8?B?aER6Rjk5MDMxNzhZczEva0NhUktpSWttemt6Zjl2VlpGcnFFOUowQWdPMkN1?=
 =?utf-8?B?YzBQQVlRdGppNVlBK3BIZEN4WFVyZEovRFJ3WUZ2aUpCbTYzblZLKzl3ZGNk?=
 =?utf-8?B?QUdpOUIrYnNCVkxCNXFrc0lpZlZLRC8wMXptQWJKa3lJVlBOeXV1ckVuTkVs?=
 =?utf-8?B?K2dCUTZGTmkxaFFWQ0VnSldBMjJOVFZlSy9mR2N0RHZMSUVsSFM3N1RISUFv?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?KzZtdTJSdkx3UmpoU0xHUzFqWjF3Y3ovMFZpZWpjQVJGajg3UTMyUHhmUS93?=
 =?utf-8?B?cGtIajErZ1AyS0UrREhxSVF0dUYwcXVJY292L3hqK1plSGVCbzh0TnJwU0Fx?=
 =?utf-8?B?RGpkR1EveDk5Q01SblMydHo4dEo0bVY5TUxvOG9relRSaG94bFNMTm5rRVBH?=
 =?utf-8?B?SlhOdFE1b3RyWmFIQk04eGdYQU41OXptS2ZkVGRGNmtxS2V2MGZ4RE1lRHRE?=
 =?utf-8?B?SU5XbGNzQkErTDhXclBLWGxwazBzd3hzdnUrb3pYT3hLcmRTTWphNys3ek1v?=
 =?utf-8?B?WnUzMy9wc1Y0c0xxMnpUbURaS09qRUpCREZ2MnJ2dUV5eFJKMmEvakpvQzBX?=
 =?utf-8?B?K00xOWxuRlJMTEJnd0NMbGVmZVVsMDN0ajkrblRYalpLTjZvVzBvS1JuQnow?=
 =?utf-8?B?SnFtZmVCVDM4c0U5cGFZM3Z4cFJsbmRHZzVMdlJWWmh6MHJpK05Ub3d0Y1dy?=
 =?utf-8?B?eUlHY3V1MXJGT0ovZzdONnBiTDgwUGJEczBYWENxTnEvZkhtMm9MUHZVcDFr?=
 =?utf-8?B?SEoyTkY0YTJvd2x6Y2xPMy8xclpic2JxejIvZVNkY2NVWU92ZlJUbk9qSEhK?=
 =?utf-8?B?S3grNjc4M0FraVY1UnlrUjdSNmhPL2pDNE9GUmUzWG8vaUUwVk52QUlkdmtO?=
 =?utf-8?B?Z3EwdW5SWWw0aDllVEdvMGhvVXM2Y0NiRGkxcitHR2tEQWV0YmtvVlF6WUZO?=
 =?utf-8?B?bk12YkJmakFBUURKaFUvODdGUEZLUlp1SjZTazltczlpZmdmYldwWit1ODlx?=
 =?utf-8?B?S3dqNFNXVmZuTnhmaTV3SWZhaHdycE9YQ1Y1eGdtdEpnUlRPVXY0Rm1zQUJq?=
 =?utf-8?B?TTczQisrbmZUa3lIanl3elBxTll6SDFmZk0ySm1PN01uVUkyNzU0eWhHRGZj?=
 =?utf-8?B?YjRxYmM2c2JuM1hXWkpTU0Jld3B4RkFRcGtoU1dBeEhXeWc2cHhMUzViUk10?=
 =?utf-8?B?Z01kbUxwTjJPdVZTbGUvcm9KM2p2ZHNFNUg5R0g4NXlxNDdXZkZtUmY4MTBP?=
 =?utf-8?B?WWtRUW94cWZaZDdERW9MOTJxVWZEQjUzOGdCNnd3aUtYVVkzS2Z3NWxtcVh1?=
 =?utf-8?B?UlkwVStoNGdkc295ZUllY1d0d0VTczg3OWNwVTFsTUZrSWRwV1FZWDU5SUZk?=
 =?utf-8?B?MDdQUU1xdVhQUkNtSDdZYzhKRVFUSDRaRXZxRWJEcmhUYi9WajEreHlSWnBk?=
 =?utf-8?B?VVBObG1QZk12dkdkL3YwZ0piNnBGeGkxd21uYS9xbmdPbm9SN1IxR2hQNlF3?=
 =?utf-8?B?MTZVVEhoTGRzamFQVC9SVWhyM0NYbE1uMHJYUWkvalVXTmpndG8rd2xMb1lu?=
 =?utf-8?B?cW1FcVpRdUtXSHBHK0JTZzBZZ29JeVZMV2J6ZFNrV3R1WTZVRkMwWjdpaS9R?=
 =?utf-8?Q?C+fDztPqQzQShi/pkGicT6Kxstjc16B0=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27262706-e392-480b-6aaa-08db6623e6bf
X-MS-Exchange-CrossTenant-AuthSource: BN7PR03MB3618.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 00:20:58.7679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9lo2WQju34zenrNXur+xSYZsMYU0/zf3uCqRpB8Xn6VA7Mu7HM1CWTdz5KHx3U+CMroAzLgKmp7Qh8nrgVYi3Oy2YqIkgV9+HznnEslFhi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5169
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/2023 5:35 pm, Josh Poimboeuf wrote:
> On Mon, Jun 05, 2023 at 02:29:02PM +0000, Jon Kohler wrote:
>> Coming back to this, what if we hoisted call vmx_spec_ctrl_restore_host above
>> FILL_RETURN_BUFFER, and dropped this LFENCE as I did here?
>>
>> That way, we wouldn’t have to mess with the internal LFENCE in nospec-branch.h,
>> and that would act as the “final line of defense” LFENCE.
>>
>> Would that be acceptable? Or does FILL_RETURN_BUFFER *need* to occur
>> before any sort of calls no matter what?
> If we go by Intel's statement that only unbalanced RETs are a concern,
> that *might* be ok as long as there's a nice comment above the
> FILL_RETURN_BUFFER usage site describing the two purposes for the
> LFENCE.
>
> However, based on Andy's concerns, which I've discussed with him
> privately (but I'm not qualified to agree or disagree with), we may want
> to just convert vmx_spec_ctrl_restore_host() to asm.  Better safe than
> sorry.  My original implementation of that function was actually asm.  I
> can try to dig up that code.

Lemme see if I can remember the whole safely position.  I've just gone
through a years worth of notes and conversations, including the
following gems:

From Intel: "And then on top of that, the LFENCE in
vmx_spec_ctrl_restore_host would save you. Fingers crossed."
From me: "The how and why is important.  Not for right now, but for the
years to come when all of this logic inevitably gets
tweaked/refactored/moved".

Date-check says 11 months...


__vmx_vcpu_run() is a leaf function as far as the kernel stack is
concerned, so to a first approximation, it behaves as such:

    VMEXIT
    RET

The RET gets a prediction from the top of the RSB (a guest controlled
value), but during execute the prediction is discovered to be wrong so a
resteer occurs, causing it to restart from __vmx_vcpu_run()'s caller.

Skipping the middle-ground with a 32-entry RSB stuffling loop, we have
the following behaviour on eIBRS parts:

    VMEXIT (flush RSB if IBRS was 1 in guest)
    Restore Host MSR_SPEC_CTRL (flush RSB if IBRS was 0 in guest)
    RET

where the RET (in theory) encounters an RSB-empty condition and falls
back to an indirect prediction.

PBRSB is a missing corner case in the hardware RSB flush, which is only
corrected after one CALL instruction architecturally retires.

The problem with mitigating however is that it is heavily entangled with
BCBS, so I refer you to
https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/analysis-speculative-execution-side-channels.html#inpage-nav-undefined-1-undefined
which describes one example of how RETs can go wrong.

The critical observation is that while for PBRSB it's the first
unbalanced RET which causes problem, as soon as *any* RET has executed
and got a bad resteer (even temporarily), you've lost all ability to
contain the damage.  So, to protect against PBRSB, one CALL instruction
must retire before *any* RET instruction executes.

Pawan's patch to turn the unconditional lfence into an else-lfence
should be safe seeing as Intel's guidance
https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html
explicitly says you can use the WRMSR to restore the host MSR_SPEC_CTRL
value as the speculation barrier.

But, the safety of vmx_spec_ctrl_restore_host() in the first place
depends on the early return never ever becoming a conditional, and the
compiler never emitting a call to memcpy()/memset()/whatever behind your
back - something which is not prohibited by noinstr.

I hope this clears things up.

~Andrew

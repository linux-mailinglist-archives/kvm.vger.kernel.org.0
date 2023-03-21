Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAC66C26A8
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 02:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCUBCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 21:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCUBCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 21:02:30 -0400
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com [216.71.155.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1310BBB4;
        Mon, 20 Mar 2023 18:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1679360548;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3l32QDPWoT4L8YbYQTaC07vTCD5oowaWruIR7Fanmko=;
  b=aNBoVKd49bBZaWacIw6JfNBHep8yBr2+JRT0a1z17zwmlVt5hyGb9lSi
   pHqAesCantITlMZJnNOFpLquxoGbv7DMNcnVtBJzImzU3CAd19b8ZTlvZ
   WnDnddSuTp9OPE2r0njHVTvCyZU7SWygJ9EHhg6mOXbruinuz0on/QT9k
   k=;
X-IronPort-RemoteIP: 104.47.73.48
X-IronPort-MID: 100430893
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:7S6xEKiY3TESF0ikdDjoZyX+X161axAKZh0ujC45NGQN5FlHY01je
 htvXz3TaPiKYGSkeNt0Povkpk8DuZHXz9VnSlRsris9Riob9cadCdqndUqhZCn6wu8v7q5Ex
 55HNoSfdpBcolv0/ErF3m3J9CEkvU2wbuOgTrWCYmYpHlUMpB4J0XpLg/Q+jpNjne+3CgaMv
 cKai8DEMRqu1iUc3lg8sspvkzsy+qWi0N8klgZmP6sT5wWGzyN94K83fsldEVOpGuG4IcbiL
 wrz5OnR1n/U+R4rFuSknt7TGqHdauePVeQmoiM+t5mK2nCulARrukoIHKN0hXNsoyeIh7hMJ
 OBl7vRcf+uL0prkw4zxWzEAe8130DYvFLXveRBTuuTLp6HKnueFL1yDwyjaMKVBktubD12i+
 tQAASgrLTucxNjn2a2hSOp1i+UED/HCadZ3VnFIlVk1DN4AaLWbH+DmwIEd2z09wMdTAfzZe
 swVLyJ1awjNaAFOPVFRD48imOCvhT/0dDgwRFC9/PJrpTSMilMqluS9WDbWUoXiqcF9t0CUv
 G/ZuU/+BQkXLoe3wjuZ6HO8wOTImEsXXapLTOXkraY60Qb7Kmo7AVpPTFWKjdOFpw2efvwAE
 2Me3xUVsv1nnKCsZpynN/Gim1aUvxhHHd5RO+w89AyJjKHT5m6xHmUYQyRTQN0gutU/STEj2
 hmOhdyBLT5uubuaUnKU8LOdrBu9PCEUKSkJYipsZQsd6vHxsZ00lFTESdMLOKq0iMDlXDL92
 TaHqAAgiLgJy80GzaO2+RbAmT3EjoiZECY26x/RU2bj6Rl2DKameYmA91fW97BDIZyfQ13Hu
 2IL8+CC4+QeJZWMkjGRWuILHaHv6/vtGDjdh1FoN4Ms+zSk5zioeoU4yDtmDE5tM8sCKXnlb
 Sf7tQpP6dlTNX2xYKlfZ4O3FtRszK78GNCjXffRBvJVb5F3dgSv8yZpakqdmWvqlSAEias4P
 4Wad8eEF3sWCa17ijGxQo81y7Y1x2Ygg3jTTJb4xg6P0LyCaXrTQrAAWGZidcg85aKA5QnQr
 dBWMpPWzw0FCLGuJC7K7YQUMFYGa2AhAoz7oNBWcejFJRd6HGYmCLnaxrZJl5FZopm5X9zgp
 hmVMnK0AnKm7ZEbAW1mskxeVY4=
IronPort-HdrOrdr: A9a23:5zKdbqlcZ6qWGJN9Q9VfOaXutX3pDfNKiWdD5ihNYBxZY6Wkfp
 +V8cjzhCWftN9OYhodcLC7V5Voj0msjKKdkrNhWotKOzOWxVdATbsSl7cKpgeNJ8SQzJ8/6U
 4NSdkaNDS0NykAsS+Y2njHLz9D+rm6GcmT7I+xrkuFDzsaE52Ihz0JdTpzeXcGIDWua6BJcq
 Z0qvA3xQZJLh8sH7iG7zQ+LqH+juyOsKijTQ8NBhYh5gXLpTS06ITiGxzd8gYCXyhJybIC93
 GAtwDi/K2sv9yy1xeZjgbontlrseqk7uEGKN2Hi8ATJDmpogG0ZL55U7nHkCEprPqp4FMKls
 CJhxs7Jcx8517YY2nwixrw3AvL1ioo9hbZuBWlqEqmhfa8aCMxCsJHi44cWhzF63A4tNU59K
 5QxWqWu7deEBuFxU3GlpP1fiAvsnDxjWspkOYVgXAaeYwCaIVJpYha2E9OCp8PEA/z9YhiOu
 hzC8P34upQbDqhHjjkl1gq5ObpcmU4Hx+ATERHksuJ0wJOlHQ89EcczNx3pAZ1yLsND71/o8
 jUOKVhk79DCuUMa7hmOesHScyrTkTQXBPlKgupUBXaPZBCH0iIh4/84b0z6u3vUocP1oEOlJ
 PIV04dnXIuenjpFdaF0PRwg17wqV2GLHfQI/xlltpEUuWWfsuvDcTDciFgryKYmYRePiWBMM
 zDfK6/AJfYXB7T8MhyrkrDsqJpWAojuf0uy6cGsm2107L2w63Rx5vmmaXoVczQOAdhfF/DKV
 0+exW2DPl8zymQKw3FaV7qKj/QRnA=
X-IronPort-AV: E=Sophos;i="5.98,277,1673931600"; 
   d="scan'208";a="100430893"
Received: from mail-dm6nam04lp2048.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.48])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Mar 2023 21:02:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Np9za98d4kFVWQbZeKuXASs1Y0JviHYtN3UMjPyYsd9+EM0b+tJEnfoE+anhAEjiKWtAnQXH5duqlfhhfaG5iZk/AOdFSk36lIPptkMssRTzEOdiqBzcEa8qb+Cjpk88q+U7EkZs7a6Zc6uYaexL/V2InqachTXa7/onl8DqyVZHVXHhqStezrMC6w+eRGHJ+Js+KVWm3dyUan29On0HgdX5cM+wGkhg5m+wqLoOPpDz1gxsoWWMSy1BjX0dWo52bDVa5Wg3M6pSrkQV0dMm4Zd5IOUza0AasPHF8dUDkDf/MKCfwncFmyxlE+NxWT5gi6gP25mrg6TWNaLW+Gf7wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3l32QDPWoT4L8YbYQTaC07vTCD5oowaWruIR7Fanmko=;
 b=I5o0wTszcudOS3fZI3lM4ApQ8FjJC3pSELyuW/OCD/DSkX9OLFQUtt4zpefmPmRLIs9Z7ykfpADf0L6Q7Gv/yL5IFTLj09eI9e2XrfxYaTEamck30TnF3+knjr5y7UZdjIzsolLRBeXz3g9pWRUG/kPEYRLz7Uwx/Pw9LzDLG+etbNdEZf5qUbQIvvgVjmrOq90MjVrjSKHShFkpIM4bj0Bu0IWsBgpVJgB2Z4IrFiURVtdBrCg60gq+KeZJn0xJKSAENW7FH17/EyYRnOjoHj9XGLJcUkrJIpJB4GdR8Z2ipIH4Q8BZOBGl1W9oqnFVIieMy3ogfdGPMIpa/BBodg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3l32QDPWoT4L8YbYQTaC07vTCD5oowaWruIR7Fanmko=;
 b=ZwRyFAED+RUJkPDa17gq/UmLq4DZcpTUYyiVyWJ2h1JFD7G13BYbqKehOBT1E5iXa0gdRRcmkvkX2uPETU0+N8dTofVs2j5yhlz08ClpJTgK4rGPxG7HgG+utYhuP0s0Wxl8mA7WnKurIhO+NfI3HKvMuKGcGY8GvJoOYyBVefE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by PH7PR03MB6969.namprd03.prod.outlook.com (2603:10b6:510:12c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 01:02:24 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 01:02:23 +0000
Message-ID: <5f81c066-d82f-b66f-9c6d-a9e6a0d5aa4f@citrix.com>
Date:   Tue, 21 Mar 2023 01:02:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
Content-Language: en-GB
To:     "Li, Xin3" <xin3.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
 <20230320164950.GR2194297@hirez.programming.kicks-ass.net>
 <SA1PR11MB67345D935A2368261E584085A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB67345D935A2368261E584085A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0234.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::30) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|PH7PR03MB6969:EE_
X-MS-Office365-Filtering-Correlation-Id: 5aaabd86-8147-4ff4-1cbe-08db29a7edfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OfGc4Id7blahMW2iLR1y/O6az7kVZhQinF9e7GuzUwGhHA6SMtgsDW0An+zJ/+CMI73S6px15DQnOus3gzix1a9We+ujIeJixVvDL4tclrEq9XvV/ByT3gNqzah3yFPncRsxNUEXR2TC8EXUXv+vT5caXDG3RriiLN+sI7EwjlVW7yifN53XCUrX3LiVaLcU+8P1Sp6G9FU44z8kiJD6P3ilz8GSjmmNGsGw+MOmijjbvaZqtB2JwZOAv/7T7QIzLNwRNlTL0xoPFZRdOILZ4o0bcT3DI9y9HRmfdG0UzZrBeUCS2V0WRQK4No2A2VOQhK0lv1sK/1TBFBq5VZIzFQ75NEm53obLxZQMvgjnhoG/9+/Lz6THwI9shu4ALqiFM5+ruyH0vOAsxzU+pGWQWD3AgudWQpKhCjJ76bzG2l33nR75ydclFAIen6ONvH8K9QSVLOdmXjdYb90EXEqsW+W/vShRt/uoTP5J/7Gtdy0IZD9E70YKo272HcUONERC1yTLI7S29H7jEtcgKwsOUrw0SeOswgbdAVSGR2wNxKEWeQJxkWIounbtfmRB9+xezizCs2pkRSoOxzsEtXzMVuL6qF4mqircgiKH7J2Rh8FN7/dUtqv7BrM0LV3P4F9urSKq+QUmvk8jDKfq0Ptge1n3Hddxkk4D8aKuBJ/URb+6DBWCZPkJL9xuHO56hFt/3+aDYq2QgsR7Lo1KCk52K5RNRqehT/Fyxf+El1VwLWkGYa6irWew1Le8SlmozJ+n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199018)(86362001)(31696002)(36756003)(83380400001)(4326008)(8676002)(316002)(53546011)(66946007)(478600001)(110136005)(186003)(54906003)(6506007)(2616005)(26005)(6512007)(31686004)(966005)(6666004)(6486002)(38100700002)(66556008)(66476007)(5930299012)(8936002)(5660300002)(7416002)(41300700001)(82960400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTFwaWkrTTM3cHdrYS93c25oNjkrcWpoKzZTRkNNTnBFclQxUHJ1QVJYbkk5?=
 =?utf-8?B?b1BBVkRpWTJUS1pXbXhLQ3JuVE40WkYyUE5PVDdZdUpScnZrdUowOWFiWm0x?=
 =?utf-8?B?YndzR2h4clhFdENWREpneG1reCtZeUE3ZU5iNCthMlg1T0Evejlsc1JsbG5Y?=
 =?utf-8?B?eGx2NTZlKzFwN0xYbEtYTGFGL2NEbVdXMWt0aWZ3R0Q1bFBNYjBxRndrN0l3?=
 =?utf-8?B?aWJxU0hxdzA1YjM2K2ZML2pSZWkyZ2RBMlNMaXBJZWt1c09BaE9BWVlSMXI5?=
 =?utf-8?B?OXhid01RUU5GcTJtZjMrbUFQMFNSczFWQXpvZXAvVWtJQWxBOVVWSVJibnJW?=
 =?utf-8?B?RzF5dkpoRWxPK2x4ZVpZbE5nK1ZmTVJLTENrVEJ0NHNnT2FRUVpNcjNsRVNj?=
 =?utf-8?B?MFNqNVEvY3lMa2ZyVExxaG9HdkhGSGNKdHhhVU1WdncrQlpLa3BoTHBaSFNM?=
 =?utf-8?B?cDZseEFpSGcwOWJib2FwUThaUU1QVzZYRlRnTzliZFJrZ1hyOS9XK1YrQXpq?=
 =?utf-8?B?LzFNdU0wUkFWVmNlbkh5cnNGcnk5NzhxZyt3NVp5R2c2VjkrM1k3Zlp1WGZF?=
 =?utf-8?B?NERZN0R1ZTFjZEE3aGxWb3BkZGV4U1hCMHFsUVo1R0tlaTJjUjdGNG1NTnI0?=
 =?utf-8?B?VXdDenFzN3hseHlIdzJKc2JqRXI5NVAwMG5tdlNhcm45TVZoMVUxNWJBZGRX?=
 =?utf-8?B?ZE03YmxNSkozcXdISGZCYlJWQVFlb2VkSis1WlYwdi83d084SWwxenA5QXE5?=
 =?utf-8?B?ZWRWWkVaMVYvMldTSW5XSXRNZURqZmVqWCtoN2F3STlrTHJLV3dKY3c1dGZx?=
 =?utf-8?B?TkNsVG42NkZEUXZIbEo4bytaQ1dMeVdIMVIwdk44YkZ5ajVLdE5oN0NsTmRw?=
 =?utf-8?B?L1I5cUd2a3BsUGRlOGY0MkJRUTlWQkxJRjRyMUd6SXVaM1JVZGU3alh0aEZP?=
 =?utf-8?B?aVQxVlUrRm5hMmREbFlZbEFRQnhzUmptQkJpSUFKeU9TNmI1SFdyMEUzK3Nu?=
 =?utf-8?B?MVViaWpTNE43akxGWUxkOEVTTCt3S2MvMC8vVFRGd3IxTTFNYUFOK1Y1RmQ0?=
 =?utf-8?B?eGV6VWR0ZTZaOWFrZkhQSll3LzQrK3V5a2RNVTBEL0VLVlpXTmVvWHpHQ1lO?=
 =?utf-8?B?M0owWUV2cnB5RVlueTZreDZnaFVvczBwOXhWOE9XZUNQdG51ZGZrYmxqVEVF?=
 =?utf-8?B?aENuYk9EanFmVU1XblRqNGhjSE5pbWVncGRSMEJLQ2NsaThhd0NZR01hbHZV?=
 =?utf-8?B?NmxLMTF4MkFqb1RDaVhOSGdhR21KOFBxSHlXaFpoc24zQ3ZMTkJuWlZsZ1pI?=
 =?utf-8?B?NU9HbGNzN0Z4MEJyTVdJLzhvSVRiUkxvWndxQTNsMW04cU5FbldoUUxXWkhR?=
 =?utf-8?B?QjBMcEl1QVVPZFR0NXU4ZUtKamR4TE5IQXFCVDlkTm82bWNQNFg2SUxuWlQ2?=
 =?utf-8?B?U1pCTGYyNVVVZDVQN0RJRitZRDl4Y2RvVThZd2N1L1BDYWR0QTRQMzNSa0dT?=
 =?utf-8?B?S29qNDNyZVEwR3lOQk10OGVwd2M3bUlwNGFJYW5qUGp0QVhCOTR5N2Z3Qkh1?=
 =?utf-8?B?QWF1WEVFTkExSXg4Q0kvWkxuZ0t6VHZVQ2dHSEFPd3hBUy90TXlxUHJnR2VT?=
 =?utf-8?B?N0E0ZkhoNElMb2VVdmlKTStzbTNyVndFRU1YejNmckpnMWlaYk9kK29pSEFw?=
 =?utf-8?B?OTRqbS9lc2FmWmV2VnFjZzBSN3ZySzhWSzRIdllYSFRhcTV3TFhtSThQYjRv?=
 =?utf-8?B?aEJ1U0srNGZDeDhqa09Ia0hGSC9XY0JOYTJjZ1MrOGliMXRQNG1mcnAxeFA1?=
 =?utf-8?B?Q3kxbjhuQS85ZDhqalc3YTRyaFN2UDFIV281OGE4TFhkMlpPLzRWU01NWGI0?=
 =?utf-8?B?Y0hQbWpRYkdVVTdVYXhKQ1IvMFVKMUt3S3BnaVhJbjJ1b2ZXeHJoNlNGYU5S?=
 =?utf-8?B?WUVsOHNZaEpkM0N5R3UzUDN0aWNCZW1JZkhkWVpaS1doYW44UzlJSG9uSzFQ?=
 =?utf-8?B?MCtidlBoT2lMdnhiekcxNGFIcHRIZkY5bmMvRTh1Nlc1Rk9lUE8wN1Z1Q0Ju?=
 =?utf-8?B?dFA1OTM1Q1ZBNGtIUkdwZWt0cHFHT054VTI0QUlDUUZPWkJhdXNiSmNCOFhx?=
 =?utf-8?B?MkVEenhUZ2VuQkJJTmVRK3BjblVYMTFvSnI2SzNWdlJSdnZDbTRJbXIyak93?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K2lYQjRUano0eVRXU2VCTGxIdGRXamRMYVZ6MmlGY2syNFJ4N3RmS0ZDR3gy?=
 =?utf-8?B?enp5WGJYR1FrOE4vekQ5Q1hWUTkvVUd6SUsvY01RSzZ6UXBSdVQ3blh1YkN6?=
 =?utf-8?B?NVJxTTNPQUxkWStYSHYvcFpkU09ERWZIeDZ0cWhNSnk3YlljTnZTV2lWZUFY?=
 =?utf-8?B?aUVjZFlGcGxzTm5ZTG5XYVZSMGZxOXFlNmh3UGE5VzM1Skx2dkJzaUxPcmFa?=
 =?utf-8?B?aHF5WGF0RVlad0JqQlFlWlpXNzJqMjBoWEtkMWNaR1A1QjhDNDFQN1JQREFl?=
 =?utf-8?B?ODhzQ3dJU092Q3JvQlRpbnR3Z3FKUU93UDJRaVVJTkl3OTRrZHp6RzBuUXRt?=
 =?utf-8?B?Q3diYkt5RmpsR3R0cXhGRnVaZ1NHVEhPTmJ6OG5OMzFhWkpZUVQ2NlRMZCtZ?=
 =?utf-8?B?OXVxZWF3YlpHQzBsQ2ZEd2JUbGx5NVFmNzh1LzZhb0RyOENtZStUaEdmNitV?=
 =?utf-8?B?L2Q0Zk9FcHduckVuZWhJWDI0MWFFYmZvQmhoUXNHT3NvSldWYXg5Zzh6L1hL?=
 =?utf-8?B?c3NheTV2R2c2ZzIxL3ZtWXY4eHFMOSsxTmZZcnZ5UFVGNUE5czNhOGIyaWdY?=
 =?utf-8?B?OXdNQ3lGb0R1d1B0L3haM2R3RUpWc09qa3BMUXhGKzkyZmwrYks0SnZDMnBx?=
 =?utf-8?B?eG4zcXZKQmhzckpJb2VFWUlDa09MTkhuYjZ3NWNnS2c0Y2JqNjUwYXZHZjY2?=
 =?utf-8?B?TWFnZnNmVmUxQXJMa0pramhYRW5vblFHMzBlNXVVUEljOHQzbjdoUDFPMjFR?=
 =?utf-8?B?TDVnUHc1amtGR2x5ZWovUUVUTWRiWnBKREpWWHVpSlVDSFFvTW5nYlo0aHhH?=
 =?utf-8?B?VFgxUDc1RU42YmdLNTd6VGdTVXZBSTlrQ0RIRElHT2JIY09YejVEck9MOWZy?=
 =?utf-8?B?YlgxcDBYN2x3WjZHZkFzcldFMVgwZTFMTjJ4WTE4WCt0UFRQaUFqK3Y4Tm9D?=
 =?utf-8?B?TlJXcFhZTnlFdlRRWUM0eGFGUXlXZi9EelZodUMvTWxkdWVXOCtsY0diQ3ha?=
 =?utf-8?B?bnBPc21EYnY1MEZJTE5qSTByZXBwWng1cEZTQVdtTkRWZFMvWi9pVTBkUkNU?=
 =?utf-8?B?WTZ3cnMyR3QwZGlTMmdYekxrZUtoWk50TTlMYU54SHUvR2NSaUFOUG00QTl4?=
 =?utf-8?B?dkl1a2gyYUpFWElwUWVrbUs1WHJpZUZtOHdqV25TbmZ0MU4rWksyL25RbFdY?=
 =?utf-8?B?Z2VRUUl3Y1lSbFM2c3FhM1Vnb2xPOWR6SzhyL205UE83ZEpZd1lDY2xnUmdC?=
 =?utf-8?B?WCt2RGcyQytqYVRzNDZQbmJjc3F6ZUh1UzZNeGt2dXlDeHErOUt2SFgwWWxR?=
 =?utf-8?B?ZkNxYnJpQ2IyWmF1SjJOQ0ZNZllPZTVmY1dOakpGekdRWGtFNlZhUSt1VGZj?=
 =?utf-8?B?d3BhWDdVeE5aaG9Qd3hyekQ5R1VONGRNOTgxdkRiOTNKNHZnemt3YXJrUlJv?=
 =?utf-8?Q?6Lc7+Fuu?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aaabd86-8147-4ff4-1cbe-08db29a7edfb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 01:02:23.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rx/zvpkjh53DO8thn1glZ2suUaupE7OZ8ggmdGTmwMvpsWczsw7nB4037cn7U1FzGRWpzjtx1QW5cCilp5SOHCM3Kt+EZH9CVpfQMjSYiX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR03MB6969
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/03/2023 12:12 am, Li, Xin3 wrote:
>>> If there is no other concrete reason other than overflowing for
>>> assigning NMI and #DB with a stack level > 0, #VE should also be
>>> assigned with a stack level > 0, and #BP too. #VE can happen anytime
>>> and anywhere, so it is subject to overflowing too.
>> So #BP needs the stack-gap (redzone) for text_poke_bp().
>>
>> #BP can end up in kprobes which can then end up in ftrace/perf, depending on
>> how it's all wired up.
>>
>> #VE is currently a trainwreck vs NMI/MCE, but I think FRED solves the worst of
>> that. I'm not exactly sure how deep the #VE handler goes.
>>
> VE under IDT is *not* using an IST, we need some solid rationales here.

#VE, and #VC on AMD, are borderline unusable.  Both under IDT and FRED.

The reason #VE is not IST is because there are plenty of real cases
where a non-malicious outer hypervisor could create reentrant faults
that lose program state.  e.g. hitting an IO instruction, then hitting
an emulated MSR.

There are fewer cases where a non-IST #VE ends up in a re-entrant fault
(IIRC, you can still manage it by unmapping the entry stack), but you're
still trusting the outer hypervisor to not e.g. unmap the SYSCALL entry
point.

FRED gets rid of the "reentrant fault overwriting it on the stack" case,
and removes the syscall gap case, replacing them instead with a stack
overflow in the worst case because there is still no upper bound to how
many times #VE can actually be delivered in the course of servicing a
single #VE.

~Andrew

P.S. While I hate to cite myself, if you haven't read
https://docs.google.com/document/d/1hWejnyDkjRRAW-JEsRjA5c9CKLOPc6VKJQsuvODlQEI/edit?usp=sharing
yet, do so.  It did feed into some of the FRED design.

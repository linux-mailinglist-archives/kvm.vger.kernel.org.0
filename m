Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7365D651E28
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiLTJ54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiLTJ5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:57:04 -0500
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com [216.71.155.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F930B12;
        Tue, 20 Dec 2022 01:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1671530137;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j1ZjB15JzM5Xe+gV8fT6B5GkZTZbhU7ktJk3LY9W1WA=;
  b=fz0Ka85TWxMoEO6uztLRILjT3cyLSEbjYyDJpwXCeSdZuSd30HulKOKn
   +DagBm/Yvbbl0F9sY0wgPeuTGhNyeGr53dP+5Ms/SmBOLcOTN5YCgfQOE
   v88SCp4L+Y5FwXbZICKgYzxKmNtWK7BQP9vVtw73GKsf5lv8Cy1hVfkS0
   U=;
X-IronPort-RemoteIP: 104.47.57.40
X-IronPort-MID: 91736257
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:suCZX6O1z8yL9EHvrR3Vl8FynXyQoLVcMsEvi/4bfWQNrUoj3zwPm
 DQbDzvXa6mLazPxKd13O4m2oxgPvpbQyN8wSgto+SlhQUwRpJueD7x1DKtS0wC6dZSfER09v
 63yTvGacajYm1eF/k/F3oDJ9CU6jufQA+KmU4YoAwgpLSd8UiAtlBl/rOAwh49skLCRDhiE/
 Nj/uKUzAnf8s9JPGj9SuvzrRC9H5qyo4mpC5ARmP5ingXeF/5UrJMNHTU2OByOQrrl8RoaSW
 +vFxbelyWLVlz9F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq/0Te5p0TJvsEAXq7vh3S9zxHJ
 HehgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/ZqAJGpfh66wGMa04AWEX0uw0Ql1v/
 KA/EjEEbEmontq74IK2EuY506zPLOGzVG8ekldJ6GmDSM0AGNXESaiM4sJE1jAtgMwIBezZe
 8cSdTtoalLHfgFLPVAUTpk5mY9EhFGmK2Ee9A3T+PVxvzC7IA9ZidABNPL8fNCQSNoTtUGfv
 m/cpEzyAw0ANczZwj2Amp6prr6WwnilAt9NfFG+3tlQoHGOhVxOMjEpcXqbvva/lGOSW/sKf
 iT4/QJr98De7neDVtThUgeqiH+CsAQVV9dZH6s98g7l4rrV5V3fAmksTzhdZdhgv8gzLRQu1
 1mUj5bqCCZpvbm9V32Q7PGXoCm0NCxTKnUNDQcUHVUt4NT5pow3yBXVQb5LE7CwpsP6FCu2w
 D2QqiU6wbIJgqYjy6q/7XjDgjSxuoLOSA8loAnaNkqg7wV2Y6a/aoCo4ESd5vFFRK6TVnGIu
 HkJnZjY4O1mJZ2EiiHLQOwLB7yvz/KENiDMx19pA5QlsT+q/haLfZhZyCNvOEBzdM0DfFfBe
 0LavwFazJBUO3SuYOl8ZIfZI9wgyq7yFNLkfurZYtpHft56cwrv1Dtne0/WwSb2kEEqkqglE
 ZadbcuoS30dDMxaICGeQu4c1fowwHk4zGaLH5TjlUz7ifyZeWKfTqoDPB2WdOcl4aiYoQLTt
 dFCK8+NzBYZW+r7CsXKzbMuwZkxBSBTLfjLRwZ/LIZv/iIO9LkdNsLs
IronPort-HdrOrdr: A9a23:VcQzl61uE5wyOWGd7BVf1gqjBJQkLtp133Aq2lEZdPUCSL3jqy
 mLpoVj6faSskd2ZJhAo6HmBEDkexnhHPFOkOos1NuZPDUO21HYSL2Kj7GSoQEIQBeOjtK1vJ
 0IG8ND4bbLfD1HZKjBgTWQIpIJ3MSA66ywgPe29QYXceioUc1dBsVCZzpz3ncYeOCOP/QEKK
 Y=
X-IronPort-AV: E=Sophos;i="5.96,259,1665460800"; 
   d="scan'208";a="91736257"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Dec 2022 04:55:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6sA2KR+uhGqaC6L2jaYYDJjmrabpgZCMHLGNbEbZFgHeJRwY6IYRe8JGOo6BSJrfqxlmm3v+3V97jfjrJzHpAn9RpLpImevOnlUHdk54NIDMxImDMW1r6e2BopXFpbEWNAbTuRFKCKd2xRkd0ilVk6iDhPlm7eOdoViFWjaB4fjJoYGvH4Z3XasxN7dBc5Btt2mXetZBpzggeJSuO41CoOQBMFaX6K4MkPF7SVGe4olUNivcuoksemSNifSR6LuYGrwaflRYxGcT58nCr0IfLdo43MfxmJ4pzyRG7lE5jnhwALFsPD5/JbbgDRO/uHUzMMq73qGcEZmi70VJRnuFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1ZjB15JzM5Xe+gV8fT6B5GkZTZbhU7ktJk3LY9W1WA=;
 b=cycjXa265cmaoBDyXJDn6kDaiA7lucCKcGvvBApmcNkapa5QIS0hGkLqkeJI2WnVRkhnGIQhEcsvMMdglimErd1IiL/P20LDjDmMub2VtskdwdcmMEd2VtQWbNnXN6QmwNHt11vJnnL5nx0GUHyOVLDOdq90s8/0d5ySpbQM9ahvLspnJA9q9U6awzoXWr8GdX4Pp5YBVj8O1ZyxWNlXUE0PDztpIvhz/1Ku68TOSJi9AdRdD+PGZQuF+zqH+IjQTq1C9RSSHFyx8PTy6R6DIa+fI7uhot3WKsgCldzqi2qxKlVNgzHphVqH6rVMLeYeKlGBV050vk7hUXquKHOFQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1ZjB15JzM5Xe+gV8fT6B5GkZTZbhU7ktJk3LY9W1WA=;
 b=Dc7lCIhgjtBDPCL/02hNSJO8VugLdbuR7On6JsnFeX5NSN48WZbEEMkDvp/EQQR6t7jEL27Rhix5LYcZOoiHS+9lKGdNIQC1Kl6CyRwVFWizXQuPMbA+UIbda5b/JZ7RX9nikP0xFtwFix2WZCI2bCF/QNdeREzpnXdqAt6MqPc=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by SJ0PR03MB5437.namprd03.prod.outlook.com (2603:10b6:a03:288::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 09:55:31 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::c679:226f:52fa:4c19]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::c679:226f:52fa:4c19%6]) with mapi id 15.20.5880.019; Tue, 20 Dec 2022
 09:55:31 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Peter Zijlstra <peterz@infradead.org>, Xin Li <xin3.li@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ravi.v.shankar@intel.com" <ravi.v.shankar@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [RFC PATCH 22/32] x86/fred: FRED initialization code
Thread-Topic: [RFC PATCH 22/32] x86/fred: FRED initialization code
Thread-Index: AQHZFEDoF4HC774utUK5tADQd2u3YK52hwiAgAAC2IA=
Date:   Tue, 20 Dec 2022 09:55:31 +0000
Message-ID: <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-23-xin3.li@intel.com>
 <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net>
In-Reply-To: <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|SJ0PR03MB5437:EE_
x-ms-office365-filtering-correlation-id: 70826b11-10fb-4272-2fc8-08dae27054de
x-ld-processed: 335836de-42ef-43a2-b145-348c2ee9ca5b,ExtAddr,ExtFwd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kUNDDMnsnoyJnF4lrFp+a/ZyArnqTGKlSF1VpIDMJAVxO+XFXE4U8KN2PJ1WYYYkNnQG4TUeXNnmo1T7MqILl3gYneMFzNFL8hcT8MsWVjCTA71RS531IDCfGn7Kal5gf13JHpq5Gs4gr6QK9ZSS4l7Gikx36nq6aA2D1uqNUf4CH8DYJac/ODpDVj1S3rR8pWoZ773bXYAWI0nLXOSrpfxrbxQRq2XE7FpeG9VVFB0u9DxR7IQtIFn8DyC1XU5rOU3j411qDv4MteOa7mxJPl/Nq6q43pdS8Ys6ITHahPYHTaxkJCjpyhmTIdS81qzy3wTHDVr1VhScjQLzJfpBzoHhw36Io37i8RK95XyAwOUFhWBC2G2cmTtIIMUVT2nj2AbLB7B7rflrwRESZ6EdYBkCmXlMNn8ZF1Fj1lH2dcAcdLIfnxagi1nbfSt2Q8NwXNwFYL/06bqVNmT6OiLX1KxXK5hrROx2iI2K3bD7uxzwYkNNvG9/szefEu3/SVJvNWoHACc5cMTLAZk8LRRusY4QTmSdT9dsJgq0zWwXlfrk8y6HRDqtPATp/CxBfzUEKOz+S4D+orMsAmcxjX3xIOhKPuXlonypJiSLCkLRkcBtXLGRk5DF2vssLpxBZrOUFupSEEvYi30q/t3lRmR+jBuDuKgPrkjMnUcVJdxb8DQ9I24BPwsc4XAlcE/6JenCKGK17vPTzcl8/GW//DXz6hRFRoor4AtkcOVlPYgY1LJiRJQfJPLbLd4i8dsYWSwJQ8+fjjfMWhHbysnMVJsltA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199015)(2616005)(82960400001)(38100700002)(86362001)(2906002)(91956017)(54906003)(38070700005)(478600001)(107886003)(6486002)(122000001)(110136005)(36756003)(316002)(31696002)(71200400001)(186003)(26005)(7416002)(5660300002)(8936002)(31686004)(6512007)(64756008)(4326008)(8676002)(76116006)(66946007)(41300700001)(66446008)(66556008)(53546011)(66476007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGNEZVFuSXZzR0N1a0FyMHpITkE2Rk9YSm8zeFJldStOd1lZdm1aYlllakk3?=
 =?utf-8?B?N2cyR2xxVElUMmtXS1gwN0VZVExHaFFlcGtGRFhEcVo5RDZ4UHRTcGhpdDg0?=
 =?utf-8?B?TE5qbVB0d1JwVkt3NDVTSDJHYkxtRytKcW9CU2RtSVNwNFBvSzdlVTRGTHV5?=
 =?utf-8?B?WGZDS1ZxMERtYTUzaUtTVzF5ckowZFVtajlOa293LytmR3gzK21CbEJBcWtU?=
 =?utf-8?B?UGhlcU1ueUlJc0FJVEdMNVpHNTlDRTZVZ0M5N0cxTTUzdGFwekh5OENYRVhD?=
 =?utf-8?B?MFlFbU9rRzJPbGpFa2FJd2FFWHhmY1p6OEtpU0NxdWdSRlRvRkRjYUR0TDUw?=
 =?utf-8?B?enFUdE80ZDRsMFoweUowQUV4UUdHODN3VmRVN2htZGpReDk4ZmR4eTVqODFh?=
 =?utf-8?B?ejJ2VzVVYkVkU0IvTEI1QkVkMmZzbkR3TTJuZFI1MEUxRko1MHVhQ3RMYUM5?=
 =?utf-8?B?ZDVRZ2w3SmNFYUR3YUlaT21NV2k5UXgxNlV5c1JoMlBiR2QwbEFlUjhtbHBC?=
 =?utf-8?B?YnB2UGkwcjUxS3JnYUtIZzNadm5xRC9oMkJLVzJVQWI4Uk83NUxGdTFxU0FK?=
 =?utf-8?B?YVBET0hZWTdhS2hoYjYwUUgwU3RqejRWMHBBcXhValhkcElsQlQrSmo3N2tv?=
 =?utf-8?B?RktoSjN5aE9LdTZaRzQrY241UkhBSmZIemljNkNRamNXTW1yazR4Z2huOHR4?=
 =?utf-8?B?NDFSV0VieklEcG1BdFREak43emE2Y3JmdkZPenQ1aDhIa1lINEdkRHR6YWxs?=
 =?utf-8?B?cmFtNzBJM1V6K3NKSHozczY3VjFYNFJFaU4zdkhwZDd5Rldxb2d3UTBHUVhu?=
 =?utf-8?B?Rno1QVJxWFVEK1Vrak1HUGkyUTZjblRhLzJlMTE1VGU1VFJQT0tZQjlyYWtq?=
 =?utf-8?B?TU1ON24ySHJEaldyaDJabjlldlBpOHVGR1JWdEJNNlRrYnN3RkdIOHArMmlu?=
 =?utf-8?B?cmdNRTVrSVh5OFo1WGlTTkNyTVFWT29VeXJNUnVpek5hM1VPWE9admN3QlhE?=
 =?utf-8?B?VSt4WXEzbVdjdmt1WVpZZWlmcFdCZ0NyZEpQZEpvY3ZOYWRBdXVxcEVNa0NX?=
 =?utf-8?B?eXp0dXFNVmpDR21JbmpIL1VWTkZSd0cyVFRGWjlES3Y5QnJrWlAyNExWemw3?=
 =?utf-8?B?amNRc0puVUpRZUdackJiRGV5N2cyYjJzZEg4TVN5Y3RjVkp2V3I0UlVoV2g0?=
 =?utf-8?B?Ukk2d2JIN2tKbmZleGF1VndPNE12TFY4R3VhRGtra3EvVWpJMDY1TTJielE4?=
 =?utf-8?B?RjF6c3lKdkZlMFVjTHNoTk1jVjRDMitVeHEwMGVXMUhwR3MvaDFKZW5mdzB5?=
 =?utf-8?B?bnMxbVA3N3lkRndyckE0ZTRjRmpHZ0UvaEwvcGtoRmVXVlR5blFUc3NiQzVk?=
 =?utf-8?B?TWJwenMvVU5iZFcybmVFQjBuV09mM084Sy81WjRSZ3MrVDFhamU1bDVwaUVN?=
 =?utf-8?B?Z2hZcm13eGtRdHVoUnY4VGJXdFN4NnVBb2dmMHE0U2V1UGUyZWxMYnRRaWxu?=
 =?utf-8?B?eGdjV0NyN1B3eUFSeklROEM3VlIvUjRZcmZXK1B4VWFwYWpFMXZyMi9UMTlE?=
 =?utf-8?B?MkRVUE0wekI5NHpVQ2wrMmtpeXZ1elRhQjk4dDhtazJjNGw0V3R1aHNwQnBq?=
 =?utf-8?B?Mko1dDFEQUdHUzMvbmY5TEZFdUt6RGZSaWVQREk0U0w0bWk2U2pHWktaZEUv?=
 =?utf-8?B?MWxERHJYdklWc2E0emdtKzY1ZzNyR2xJNEM4Ym1GbDBnTlMvQTEwNkplaVVF?=
 =?utf-8?B?R3BjWHE0ZHJ3cDFiWEFsekEzNGRtRWN6NHozd1RVR2lZd3JlZU1KWmhKQ2JL?=
 =?utf-8?B?Q0ljam13TGdmS2NyeUM3dG9XUENDMHJTZkcxaWNWOHRDcmlXNHlabU5Kak9T?=
 =?utf-8?B?UnkrY01pYWdTRm9VQnI3THV3QS93eWExMGxvSmtoVVhqR1p1enAvaTlCeEYx?=
 =?utf-8?B?Qkc2VUZHK3RXWXF6amFudUtHdXhKSktSZTFjZ3YzODdjU2FyTlJzSlBiQ3o4?=
 =?utf-8?B?N05lckVNaFNjcTZ5WXErWjd6eWxVM0IwU3NLYkpIcDNydTZNMXJpcS94QWx2?=
 =?utf-8?B?L2JjVWN2Ti9UMUR2ZU9DaGZmc3Z6eVBuNyt6NWdoT0habjFMdzdZN1hlekgx?=
 =?utf-8?Q?BuSTaygK9NSvxf5oXfZ8+ebPO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78DE5E4C1572C14DB462D77876FC25CD@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70826b11-10fb-4272-2fc8-08dae27054de
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2022 09:55:31.2689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QAliajOxelYFVLG+QV0gqOGPUMEa701aeVm2cfT+Am6aFqKpZtHY9FRHwLxQVJrvuiGsUNJpXG4BtH3Dz5+jJ+zHlbDxTvoh8VLooH2AOQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5437
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjAvMTIvMjAyMiA5OjQ1IGFtLCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4gT24gTW9uLCBE
ZWMgMTksIDIwMjIgYXQgMTA6MzY6NDhQTSAtMDgwMCwgWGluIExpIHdyb3RlOg0KPg0KPj4gKwl3
cm1zcmwoTVNSX0lBMzJfRlJFRF9TVEtMVkxTLA0KPj4gKwkgICAgICAgRlJFRF9TVEtMVkwoWDg2
X1RSQVBfREIsICAxKSB8DQo+PiArCSAgICAgICBGUkVEX1NUS0xWTChYODZfVFJBUF9OTUksIDIp
IHwNCj4+ICsJICAgICAgIEZSRURfU1RLTFZMKFg4Nl9UUkFQX01DLCAgMikgfA0KPj4gKwkgICAg
ICAgRlJFRF9TVEtMVkwoWDg2X1RSQVBfREYsICAzKSk7DQo+PiArDQo+PiArCS8qIFRoZSBGUkVE
IGVxdWl2YWxlbnRzIHRvIElTVCBzdGFja3MuLi4gKi8NCj4+ICsJd3Jtc3JsKE1TUl9JQTMyX0ZS
RURfUlNQMSwgX190aGlzX2NwdV9pc3RfdG9wX3ZhKERCKSk7DQo+PiArCXdybXNybChNU1JfSUEz
Ml9GUkVEX1JTUDIsIF9fdGhpc19jcHVfaXN0X3RvcF92YShOTUkpKTsNCj4+ICsJd3Jtc3JsKE1T
Ul9JQTMyX0ZSRURfUlNQMywgX190aGlzX2NwdV9pc3RfdG9wX3ZhKERGKSk7DQo+IE5vdCBxdWl0
ZS4uIElJUkMgZnJlZCBvbmx5IHN3aXRjaGVzIHRvIGFub3RoZXIgc3RhY2sgd2hlbiB0aGUgbGV2
ZWwgb2YNCj4gdGhlIGV4Y2VwdGlvbiBpcyBoaWdoZXIuIFNwZWNpZmljYWxseSwgaWYgd2UgdHJp
Z2dlciAjREIgd2hpbGUgaW5zaWRlDQo+ICNOTUkgd2Ugd2lsbCBub3Qgc3dpdGNoIHRvIHRoZSAj
REIgc3RhY2sgKHNpbmNlIDEgPCAyKS4NCg0KVGhlcmUgbmVlZHMgdG8gYmUgYSBuZXcgc3RhY2sg
Zm9yICNERiwgYW5kIGp1c3QgcG9zc2libHkgb25lIGZvciAjTUMuwqANCk5NSSBhbmQgI0RCIGRv
IG5vdCBuZWVkIHNlcGFyYXRlIHN0YWNrcyB1bmRlciBGUkVELg0KDQo+IE5vdywgYXMgbWVudGlv
bmVkIGVsc2V3aGVyZSwgaXQgYWxsIG5lc3RzIGEgbG90IHNhbmVyLCBidXQgc3RhY2sNCj4gZXho
YXVzdGlvbiBpcyBzdGlsbCBhIHRoaW5nLCBnaXZlbiB0aGUgYWJvdmUsIHdoYXQgaGFwcGVucyB3
aGVuIGEgI0RCDQo+IGhpdHMgYW4gI05NSSB3aGljaCB0aWNrbGVzIGEgI1ZFIG9yIHNvbWV0aGlu
Zz8NCj4NCj4gSSBkb24ndCB0aGluayB3ZSd2ZSBpbmNyZWFzZWQgdGhlIGV4Y2VwdGlvbiBzdGFj
ayBzaXplLCBidXQgcGVyaGFwcyB3ZQ0KPiBzaG91bGQgZm9yIEZSRUQ/DQoNCk5vdCBzdXJlIGlm
IGl0IG1hdHRlcnMgdG9vIG11Y2ggLSBpdCBkb2Vzbid0IHNlZW0gdXNlZnVsbHkgZGlmZmVyZW50
IHRvDQpJRFQgZGVsaXZlcnkuwqAgI0RCIHNob3VsZG4ndCBnZXQgdG9vIGRlZXAsIGFuZCBOTUkg
Z2V0cyBwcm9wZXJseQ0KaW5oaWJpdGVkIG5vdy4NCg0KfkFuZHJldw0K

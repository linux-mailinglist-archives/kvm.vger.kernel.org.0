Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B27515E69
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 16:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242560AbiD3OzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Apr 2022 10:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242132AbiD3OzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Apr 2022 10:55:08 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE2D3298F;
        Sat, 30 Apr 2022 07:51:45 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23UBO3Ip026088;
        Sat, 30 Apr 2022 07:50:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=K0iZZpJWqBQjqaQpzBEAo56IfhQTAOjpS/qrqoqQACM=;
 b=0veEsLcFpGdRn8e7P7uGSsZNhDw86yWLIJL7kChVTc4eE1quZahkMjxhGhAliA1a65U1
 AyVqRVvGiCycqsm08tjrfCO1pvaAUKbH/F2kLvcivPjBHAtW5KN/bHITfi3tZw9yaE+h
 V8uRJ2M6LlxtsN5xjCJzlmY/j6gZBT4tGCzY0CmhnBHfCVYcw9NZcxLmB4I/25Z0F8xX
 Z8sbCBcGJ1BxsGpWR4Ulv6sHLbBi01JHotrX+zBvJORUQrhSggZqhZwSmBGUQsoyMLNt
 O/qWiZjdM8FmAfhTGoo8TiIpyHInHYd/Ijo3oDM1ggmEN39Fsgm1o+eGiUM1OgwJVBcP /A== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fs46g8623-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 Apr 2022 07:50:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVa7d66qe+0jX1e4t9KvqGX8D06qnHKxc7vZBEkM9I5QGiOB707t1dxUS55sMCmyidYsSmHUktH282x7QTRV9MIQZI320SMM7+EqtwROFoGmedjpGBHT4NKEZbB6Ch9exh/IpJTxS9jlLa3ohRztC2kE/YC1gLkYhzLmrfIFgMnFpR4TwDmXPnat9QZJqse7nhYuxiSgBlyBQsqeg2XwC1THSz6+yyc0zCmO0go5vNVPCsAi/u9lFPVNByBWGA5srGbNuuot2q/TDghATBLW4yusHgKqvxi4mhLzngsPB5zO1BoEPrMUfx1YO1JyssD8/+9+sBA9KGL8OkqzkYyRKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0iZZpJWqBQjqaQpzBEAo56IfhQTAOjpS/qrqoqQACM=;
 b=dcDsN0bDy1Ril5oPoJ8JYPRumeSH1WiOZX0TuSguA6GXgg2+Mkc/omaaf4EeWbryYsa4mA+uEbzcs4QteSs61spkIKAx8BmefCaYOnzUqcFuYf24dNoBKqgcZveu86Ai/Kw+N3OM/lCMSHuPCV6Rt6DgkaQb7ElpTM/Rf3uHcaTWEJZcFEzi0CaZ89Z6w2K8TxcjjIUllsWhiRNGWfn6dCAy1iTlEtN16wYMEythHs9uR5/8v5pgLWYI+ZIrCNx7WKN2fvWiQLnBJ3ImOyeUQ/CY+S5F+rhMa17OD7xk/wOf7R/hS3eeV33du81FjGWBzMOxhDKcgaL9+kNg5qxRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM6PR02MB6683.namprd02.prod.outlook.com (2603:10b6:5:218::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sat, 30 Apr
 2022 14:50:35 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 14:50:35 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Sean Christopherson <seanjc@google.com>,
        Jon Kohler <jon@nutanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Topic: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Index: AQHYVmUALWKOwI7bhUetXwvEOXsG/a0HKBwAgAAI9ICAACHkgIAAD+oAgAAIS4CAABD0AIAABkcAgAARGQCAAK85AIAAU8oA
Date:   Sat, 30 Apr 2022 14:50:35 +0000
Message-ID: <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic> <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic> <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic> <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic> <YmxzdAbzJkvjXSAU@google.com>
 <Ym0GcKhPZxkcMCYp@zn.tnic>
In-Reply-To: <Ym0GcKhPZxkcMCYp@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a9478fd-a1c4-4e25-4afe-08da2ab8c8d0
x-ms-traffictypediagnostic: DM6PR02MB6683:EE_
x-microsoft-antispam-prvs: <DM6PR02MB66839BFD0EEF352063CCB010AFFF9@DM6PR02MB6683.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QG+VLcz4wlkaImUmnv5os161LdCKxDsFlULU47CbPFUGyYQDVMs0EyZR8+7OyHqZYf/SlkEE9wdkrinuI2DUGlEjJwfulKO+MJPcZ6M67Gg0lKCo8EiPzguQaioLFlqBOgHByAmmYhKBIqOf7P0QXIwsC1UiHxWwFGVIlgQ4jsrunW7jpiviFCaBvxwPOEuhlFk4NGEoaooExrAkN0Yl+5lCcP5MKFBY39EQWNIRp2kVGy3ZevT8zcdEBbsxmgHQwMARkDs/TCs8dd6z6YrQrd+MnsHFyBfnVC+r01F/iv9P2byKL18OSSajLRIintqffmbIFGM0Z9EM9ymJiquJNZMTKsTwkFnqZFyCwtKCgPc6UayZDYX4mOCAn6O/wLEt+5ptQYGVPX/+h9wdGy5ZmS4KWbptJePmmyqnqG3OLiXoz2kazHY2l/YOAnO5SJYmCaQVBxdQNL58Av2uYwgYBaD6fvyCUBT+AuQ0aaeAqUXeNWEl90sdgSCck1hp/JaGM5VDe8JvICFxRKgw9+IeZKIA6qIEiU9PWudqOorv/Q6XEVBa/8+Uw6hfRtfPXoI9p/EqdN8W+fqJBF/jIZ85Qm2CyxjR0H5Q1/X4rqzF46mytBpETqq58UYeXqHIHKOcRx1sJ3bRBtGGiCaPKY2JOSr5HRFAw4z7KV1fpih2PEyJoGBWY0kJ68bIzHS9nw8UmuRl6UyIizpNHPDVZ+YlP6Tqz5AsOjsjvtaF1SIpUIKzozfjXwqhUAfZT4SR8xV0yfM5XVRlst2L0yQyf4q/WXzyWXMv+u8OosKC4D74HMk3cyDjorW+5u0xSfe6TpUX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38070700005)(33656002)(66946007)(66446008)(66476007)(64756008)(86362001)(508600001)(66556008)(2906002)(5660300002)(4326008)(6486002)(76116006)(966005)(91956017)(36756003)(53546011)(71200400001)(6506007)(6512007)(26005)(8676002)(7416002)(122000001)(186003)(2616005)(6916009)(316002)(83380400001)(54906003)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUQrSmxacnYxN09XWVVkd1l2L3RPdmM4dllJUzRVcWNodElUZjhlMHlBS1pH?=
 =?utf-8?B?N1U3SndKUjRrbitjZjI4VzNGSXZJUkRKL2tndUJwaHc3Q0FTZEZoVWJHbFVY?=
 =?utf-8?B?a0t4VHMzRUVPZU5hM2U2ajFRQVV2VE1TeDZzRHF5UEJkUjFaclNoRmp1OEpu?=
 =?utf-8?B?THBsSDBNZGI3TFRwVVdSNlp2NXVjb1d2RUNkNHRva242c2tIazBmQk5wVFM1?=
 =?utf-8?B?TFRnRGVld3J1T0NKOWpGaUVsVHgxaFZ2TjFsakVUcGdBcDR4T0luL2k0cnBX?=
 =?utf-8?B?d0I4UnNHWEU4NTRDT2twMW5yZzdtVU91REJOeFdhMW95bk5xSXJqUjhucFVM?=
 =?utf-8?B?dWd5dDJ2aG4ydWZzTTdGdzhrejVlQTV4ZVBWM1JmZmkxY0Zwc1VsNWt2S21X?=
 =?utf-8?B?OGRabkNFNTlZQThnMUJvSWdYck5jZHdlYmRka0oyREpIL1RPYmx5aVFJSkh3?=
 =?utf-8?B?SmNBd1Y2ZFFuTVNpMUVqSEVBY3R4ckllWDFNVEZwVlE1NHVHOE1xMFZWQS9Z?=
 =?utf-8?B?aDVtV2ZCUUtQRkoxajhaaFNUNWI5dDlPTFFERzJCTCs1MWxJWkRTTzh3OG1i?=
 =?utf-8?B?bDZhdFp2bExabmw1Vktka25pZEQ3dzA1TnU2dEtVVk83Z2pFaVN3aktONVBR?=
 =?utf-8?B?VEU3RmZncmZOL0ZMS2t3cWxWdFBSallKTlF3Y3FKeDY3UFdmR3E3QkVKSGdy?=
 =?utf-8?B?U0twQWsvTWFlQ0t5KzZaanN5Zmk0WDNjUU9GQ2U4ZnJZeWt1Yk5YRDUvMFg2?=
 =?utf-8?B?TndpZHVKNTBpVklCZmw1Qkc5cGpUNGNnZUpxVERLQTJNdVZPTlc2aUp4Mmpi?=
 =?utf-8?B?djhid1cwazhNb3RyV2NLMzJVZHIzR3l2dlFyejlKaGpnckxPM0hQMkZZN09K?=
 =?utf-8?B?VWNMY0toWEZOSXIxQkVXYjlQZjRqL09JS0VlbFZ0b1ljaFd6SVhUS2tyV3Ns?=
 =?utf-8?B?WU5ZWXMrN0hqeGZjbndteWFwZ3k0dUdjRjFhVXB6eWhLV1NObno5eHR1TkRQ?=
 =?utf-8?B?R1Arc2VRclJjS0NnR3VUUktwZGhrbndTakFmNDlwSGY5YWFSUys4UlhqcjJa?=
 =?utf-8?B?Y01sSWM0bDFjRlFRTUl6WUoxWHVpZ1ZOc3hMQmdLSXFOaVZ3Y1B1TysvMGpk?=
 =?utf-8?B?UXZieGF3YlZNSHJCR3JtSWVGWHJkQ21xdStKQi83cWRyM0dQVEluMjMra3VH?=
 =?utf-8?B?Yll5Mm80MUM3Z0c2eTdWS2E1RSszdlZqS1JhNDlYK3h5ZHVpTGNmVjdIbG42?=
 =?utf-8?B?V1o1VW95dnltUmxMQkxDVXdzSk1UNDQ0QjZpUEpCdFZCVEtHdlZiM1FzQXBG?=
 =?utf-8?B?YUVkNitJVnlrYXhCeUlacjZhUWQyaTN3Sm13NjlVVVoxeWNEYVN3aHh0Tk9F?=
 =?utf-8?B?T29pZ3pDMTNJa1lqWlNHZWVDY0xZY21ZTm91MURqeXJzOUFzZlluSU8rL0x5?=
 =?utf-8?B?d3hkaTU1YTNNSk9qdEJEdUZPbVk0SHJKay9qdFJ4NHdkNkJYWUxSRTdlRUlL?=
 =?utf-8?B?aFBFelpFK2lTMHFYTStwVitXVUV2dDluQW1lQktxUzdveUx6U3dKQlF0M0ZE?=
 =?utf-8?B?aWJBNVg0d0JVRzVrSjdzVUkrU2RMRVphZmhVS3E2bjU5TXBqTzdmVzJxcWNr?=
 =?utf-8?B?bm9Dd1hZbGcva3ZEdFY5UFI3MVNYUTFWMDhXTTNDQmtadDNaMWkvcURnYkpi?=
 =?utf-8?B?S1gyeVlrdCt5NGJvM2VPTGYyNkNBVElGdDNZVlRaOHdYOFBzT3VxVUxqMjU4?=
 =?utf-8?B?ZDlGVEkvcDRERGE2TUNVZXpGWVlwOHF0bUduWFpHYWF0Tm8ybmltejJaZnp5?=
 =?utf-8?B?RFVGMWxTVVZJNXNZQU51SEFmaW0wazVPckJ2TkpEMnJlN1NJOUpYYjdaVEln?=
 =?utf-8?B?Mmo2VnRLTlhyZm1pem5iSHlaVVdmUjdENm52T09vU0NvcEgrMGF6c1pCVElr?=
 =?utf-8?B?TEJNU3pDVTRnOUsyeWFRcmNZRUlYNHNuWWtkeUZzSm5TRFF2b2NqOWlYeWhT?=
 =?utf-8?B?TmtKS0RraTlJNnhMU05KTHQ3bStxTUljUWhLcUVCUzEyZnRuNEI2RDk3aFY4?=
 =?utf-8?B?U091K2prMGhiQklOSU9Wcm95NjlMMEw3bHJlYlFzNnY5Rm5icXRKUExjUE4z?=
 =?utf-8?B?ZzhPRHlqbXVER3FydDNJK24wcmY3djJlVEJoVjI3VlFkRDBueGZtdjVHajBr?=
 =?utf-8?B?U2hSQTFpT3NsZUhOazZUczBXUlBIMFBlem5wS0lmbCtaTHRaYmcwMEZ5Zkxz?=
 =?utf-8?B?bU9lZm5LTHoxcDVYbTZod0dJUjVCdTNJbGRDb0ZpL09RckFpNjlQclRXOEZ0?=
 =?utf-8?B?R3VZTFR3S25LTVdGdXU1V0dVanFZRU1BZXR2aFhNZVpPdkpXNjJ5bGR6SzRZ?=
 =?utf-8?Q?nUryk84/FHzoo1Nc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4F336EEF8EE944F867220ED42B33315@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9478fd-a1c4-4e25-4afe-08da2ab8c8d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2022 14:50:35.7633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xWreXrPbOarlHMYdXd4lICAUTCW9M+SCoqaT8shZ2AI/ois8oVrSMuReuXfHDVmVGShTIMQgjbh4yLL/EEdVbicozNEr5bRd11y+hI0D5rM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6683
X-Proofpoint-GUID: dvMTg3p2xdH8DxDfT9YJUiLGKu1Td4Pw
X-Proofpoint-ORIG-GUID: dvMTg3p2xdH8DxDfT9YJUiLGKu1Td4Pw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-30_05,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gQXByIDMwLCAyMDIyLCBhdCA1OjUwIEFNLCBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFs
aWVuOC5kZT4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIEFwciAyOSwgMjAyMiBhdCAxMToyMzozMlBN
ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPj4gVGhlIGhvc3Qga2VybmVsIGlz
IHByb3RlY3RlZCB2aWEgUkVUUE9MSU5FIGFuZCBieSBmbHVzaGluZyB0aGUgUlNCIGltbWVkaWF0
ZWx5DQo+PiBhZnRlciBWTS1FeGl0Lg0KPiANCj4gQWgsIHJpZ2h0Lg0KPiANCj4+IEkgZG9uJ3Qg
a25vdyBkZWZpbml0aXZlbHkuICBNeSBndWVzcyBpcyB0aGF0IElCUEIgaXMgZmFyIHRvbyBjb3N0
bHkgdG8gZG8gb24gZXZlcnkNCj4+IGV4aXQsIGFuZCBzbyB0aGUgb251cyB3YXMgcHV0IG9uIHVz
ZXJzcGFjZSB0byByZWNvbXBpbGUgd2l0aCBSRVRQT0xJTkUuICBXaGF0IEkNCj4+IGRvbid0IGtu
b3cgaXMgd2h5IGl0IHdhc24ndCBpbXBsZW1lbnRlZCBhcyBhbiBvcHQtb3V0IGZlYXR1cmUuDQo+
IA0KPiBPciwgd2UgY291bGQgYWRkIHRoZSBzYW1lIGxvZ2ljIG9uIHRoZSBleGl0IHBhdGggYXMg
aW4gY29uZF9taXRpZ2F0aW9uKCkNCj4gYW5kIHRlc3QgZm9yIExBU1RfVVNFUl9NTV9JQlBCIHdo
ZW4gdGhlIGhvc3QgaGFzIHNlbGVjdGVkDQo+IHN3aXRjaF9tbV9jb25kX2licGIgYW5kIHRodXMg
YWxsb3dzIGZvciBjZXJ0YWluIGd1ZXN0cyB0byBiZQ0KPiBwcm90ZWN0ZWQuLi4NCg0KVGhpcyBp
cyByb3VnaGx5IHdoYXQgdGhlIHYxIG9mIHRoaXMgcGF0Y2ggZGlkLiAqaWYqIHdlIGtlZXAgaXQg
aGVyZSwgdG8gZml4IHRoaXMgYnVnDQp3ZeKAmWQgaGF2ZSB0byBicmluZyB0aGlzIGxvZ2ljIGhl
cmUgZm9yIHN1cmUuDQoNCj4gDQo+IEFsdGhvdWdoLCB0aGF0IHVzZSBjYXNlIHNvdW5kcyBraW5k
YSBtZWg6IEFGQUlVLCB0aGUgYXR0YWNrIHZlY3RvciBoZXJlDQo+IHdvdWxkIGJlLCBwcm90ZWN0
aW5nIHRoZSBndWVzdCBmcm9tIGEgbWFsaWNpb3VzIGtlcm5lbC4gSSBndWVzcyB0aGlzDQo+IG1p
Z2h0IG1hdHRlciBmb3IgZW5jcnlwdGVkIGd1ZXN0cyB0aG8uDQo+IA0KPj4gSSdsbCB3cml0ZSB1
cCB0aGUgYml0cyBJIGhhdmUgbXkgaGVhZCB3cmFwcGVkIGFyb3VuZC4NCj4gDQo+IFRoYXQncyBu
aWNlLCB0aGFua3MhDQoNCkFncmVlZCwgdGh4IFNlYW4sIEkgcmVhbGx5IGFwcHJlY2lhdGUgaXQu
DQoNCj4+IEkgZG9uJ3Qga25vdyBvZiBhbnkgYWN0dWFsIGV4YW1wbGVzLiAgQnV0LCBpdCdzIHRy
aXZpYWxseSBlYXN5IHRvIGNyZWF0ZSBtdWx0aXBsZQ0KPj4gVk1zIGluIGEgc2luZ2xlIHByb2Nl
c3MsIGFuZCBzbyBwcm92aW5nIHRoZSBuZWdhdGl2ZSB0aGF0IG5vIG9uZSBydW5zIG11bHRpcGxl
IFZNcw0KPj4gaW4gYSBzaW5nbGUgYWRkcmVzcyBzcGFjZSBpcyBlc3NlbnRpYWxseSBpbXBvc3Np
YmxlLg0KPj4gDQo+PiBUaGUgY29udGFpbmVyIHRoaW5nIGlzIGp1c3Qgb25lIHNjZW5hcmlvIEkg
Y2FuIHRoaW5rIG9mIHdoZXJlIHVzZXJzcGFjZSBtaWdodA0KPj4gYWN0dWFsbHkgYmVuZWZpdCBm
cm9tIHNoYXJpbmcgYW4gYWRkcmVzcyBzcGFjZSwgZS5nLiBpdCB3b3VsZCBhbGxvdyBiYWNraW5n
IHRoZQ0KPj4gaW1hZ2UgZm9yIGxhcmdlIG51bWJlciBvZiBWTXMgd2l0aCBhIHNpbmdsZSBzZXQg
b2YgcmVhZC1vbmx5IFZNQXMuDQo+IA0KPiBXaHkgSSBrZWVwIGhhcnBpbmcgYWJvdXQgdGhpczog
c28gbGV0J3Mgc2F5IHdlIGV2ZW50dWFsbHkgYWRkIHNvbWV0aGluZw0KPiBhbmQgdGhlbiBtb250
aHMsIHllYXJzIGZyb20gbm93IHdlIGNhbm5vdCBmaW5kIG91dCBhbnltb3JlIHdoeSB0aGF0DQo+
IHRoaW5nIHdhcyBhZGRlZC4gV2Ugd2lsbCBsaWtlbHkgcmVtb3ZlIGl0IG9yIHN0YXJ0IHdhc3Rp
bmcgdGltZSBmaWd1cmluZw0KPiBvdXQgd2h5IHRoYXQgdGhpbmcgd2FzIGFkZGVkIGluIHRoZSBm
aXJzdCBwbGFjZS4NCj4gDQo+IFRoaXMgdmVyeSBxdWVzdGlvbmluZyBrZWVwcyBwb3BwaW5nIHVw
IGFsbW9zdCBvbiBhIGRhaWx5IGJhc2lzIGR1cmluZw0KPiByZWZhY3RvcmluZyBzbyBJJ2QgbGlr
ZSBmb3IgdXMgdG8gYmUgYmV0dGVyIGF0IGRvY3VtZW50aW5nICp3aHkqIHdlJ3JlDQo+IGRvaW5n
IGEgY2VydGFpbiBzb2x1dGlvbiBvciBmdW5jdGlvbiBvciB3aGF0ZXZlci4NCg0KVGhpcyBpcyAx
MDAlIGEgZmFpciBhc2ssIEkgYXBwcmVjaWF0ZSB0aGUgZGlsaWdlbmNlLCBhcyB3ZeKAmXZlIGFs
bCBiZWVuIHRoZXJlDQpvbiB0aGUg4oCYb3RoZXIgc2lkZeKAmSBvZiBjaGFuZ2VzIHRvIGNvbXBs
ZXggYXJlYXMgYW5kIHNwZW5kIGhvdXJzIGRpZ2dpbmcgb24NCmdpdCBoaXN0b3J5LCBMS01MIHRo
cmVhZHMsIFNETS9BUE0sIGFuZCBvdGhlciBzb3VyY2VzIHRyeWluZyB0byBkZXJpdmUNCndoeSB0
aGUgaGVjayBzb21ldGhpbmcgaXMgdGhlIHdheSBpdCBpcy4gSeKAmW0gMTAwJSBnYW1lIHRvIG1h
a2Ugc3VyZSB0aGlzDQppcyBhIGdvb2QgY2hhbmdlLCBzbyB0cnVseSB0aGFuayB5b3UgZm9yIGhl
bHBpbmcgaG9sZCBhIGhpZ2ggcXVhbGl0eSBiYXIuDQoNCj4gQW5kIHRoaXMgaXMgZG91Ymx5IGlt
cG9ydGFudCB3aGVuIGl0IGNvbWVzIHRvIHRoZSBodyBtaXRpZ2F0aW9ucyBiZWNhdXNlDQo+IGlm
IHlvdSBsb29rIGF0IHRoZSBwcm9ibGVtIHNwYWNlIGFuZCBhbGwgdGhlIHBvc3NpYmxlIGlmcyBh
bmQgd2hlbnMgYW5kDQo+IGJ1dCh0KXMsIHlvdXIgaGVhZCB3aWxsIHNwaW4gaW4gbm8gdGltZS4N
Cj4gDQo+IFNvIEknbSByZWFsbHkgc2NlcHRpY2FsIHdoZW4gdGhlcmUncyBub3QgZXZlbiBhIHNp
bmdsZSBhY3R1YWwgdXNlIGNhc2UNCj4gdG8gYSBwcm9wb3NlZCBjaGFuZ2UuDQo+IA0KPiBTbyBK
b24gc2FpZCBzb21ldGhpbmcgYWJvdXQgb3ZlcnN1YnNjcmlwdGlvbiBhbmQgYSBsb3Qgb2YgdkNQ
VQ0KPiBzd2l0Y2hpbmcuIFRoYXQgc2hvdWxkIGJlIHRoZXJlIGluIHRoZSBkb2NzIGFzIHRoZSB1
c2UgY2FzZSBhbmQNCj4gZXhwbGFpbmluZyB3aHkgZHJvcHBpbmcgSUJQQiBkdXJpbmcgdkNQVSBz
d2l0Y2hlcyBpcyByZWR1bmRhbnQuDQo+IA0KPj4gSSB0cnVseSBoYXZlIG5vIGlkZWEsIHdoaWNo
IGlzIHBhcnQgb2YgdGhlIHJlYXNvbiBJIGJyb3VnaHQgaXQgdXAgaW4gdGhlIGZpcnN0DQo+PiBw
bGFjZS4gIEknZCBoYXZlIGhhcHBpbHkganVzdCB3aGFja2VkIEtWTSdzIElCUEIgZW50aXJlbHks
IGJ1dCBpdCBzZWVtZWQgcHJ1ZGVudA0KPj4gdG8gcHJlc2VydmUgdGhlIGV4aXN0aW5nIGJlaGF2
aW9yIGlmIHNvbWVvbmUgd2VudCBvdXQgb2YgdGhlaXIgd2F5IHRvIGVuYWJsZQ0KPj4gc3dpdGNo
X21tX2Fsd2F5c19pYnBiLg0KPiANCj4gU28gbGV0IG1lIHRyeSB0byB1bmRlcnN0YW5kIHRoaXMg
dXNlIGNhc2U6IHlvdSBoYXZlIGEgZ3Vlc3QgYW5kIGEgYnVuY2gNCj4gb2YgdkNQVXMgd2hpY2gg
YmVsb25nIHRvIGl0LiBBbmQgdGhhdCBndWVzdCBnZXRzIHN3aXRjaGVkIGJldHdlZW4gdGhvc2UN
Cj4gdkNQVXMgYW5kIEtWTSBkb2VzIElCUEIgZmx1c2hlcyBiZXR3ZWVuIHRob3NlIHZDUFVzLg0K
PiANCj4gU28gZWl0aGVyIEknbSBtaXNzaW5nIHNvbWV0aGluZyAtIHdoaWNoIGlzIHBvc3NpYmxl
IC0gYnV0IGlmIG5vdCwgdGhhdA0KPiAicHJvdGVjdGlvbiIgZG9lc24ndCBtYWtlIGFueSBzZW5z
ZSAtIGl0IGlzIGFsbCB3aXRoaW4gdGhlIHNhbWUgZ3Vlc3QhDQo+IFNvIHRoYXQgZXhpc3Rpbmcg
YmVoYXZpb3Igd2FzIHNpbGx5IHRvIGJlZ2luIHdpdGggc28gd2UgbWlnaHQganVzdCBhcw0KPiB3
ZWxsIGtpbGwgaXQuDQoNCkNsb3NlLCBpdHMgbm90IDEgZ3Vlc3Qgd2l0aCBhIGJ1bmNoIG9mIHZD
UFUsIGl0cyBhIGJ1bmNoIG9mIGd1ZXN0cyB3aXRoDQphIHNtYWxsIGFtb3VudCBvZiB2Q1BVcywg
dGhhdHMgdGhlIHNtYWxsIG51YW5jZSBoZXJlLCB3aGljaCBpcyBvbmUgb2YgDQp0aGUgcmVhc29u
cyB3aHkgdGhpcyB3YXMgaGFyZCB0byBzZWUgZnJvbSB0aGUgYmVnaW5uaW5nLiANCg0KQUZBSUss
IHRoZSBLVk0gSUJQQiBpcyBhdm9pZGVkIHdoZW4gc3dpdGNoaW5nIGluIGJldHdlZW4gdkNQVXMN
CmJlbG9uZ2luZyB0byB0aGUgc2FtZSB2bWNzL3ZtY2IgKGkuZS4gdGhlIHNhbWUgZ3Vlc3QpLCBl
LmcuIHlvdSBjb3VsZCANCmhhdmUgb25lIFZNIGhpZ2hseSBvdmVyc3Vic2NyaWJlZCB0byB0aGUg
aG9zdCBhbmQgeW91IHdvdWxkbuKAmXQgc2VlDQplaXRoZXIgdGhlIEtWTSBJQlBCIG9yIHRoZSBz
d2l0Y2hfbW0gSUJQQi4gQWxsIGdvb2QuIA0KDQpSZWZlcmVuY2Ugdm14X3ZjcHVfbG9hZF92bWNz
KCkgYW5kIHN2bV92Y3B1X2xvYWQoKSBhbmQgdGhlIA0KY29uZGl0aW9uYWxzIHByaW9yIHRvIHRo
ZSBiYXJyaWVyLg0KDQpIb3dldmVyLCB0aGUgcGFpbiByYW1wcyB1cCB3aGVuIHlvdSBoYXZlIGEg
YnVuY2ggb2Ygc2VwYXJhdGUgZ3Vlc3RzLA0KZXNwZWNpYWxseSB3aXRoIGEgc21hbGwgYW1vdW50
IG9mIHZDUFVzIHBlciBndWVzdCwgc28gdGhlIHN3aXRjaGluZyBpcyBtb3JlDQpsaWtlbHkgdG8g
YmUgaW4gYmV0d2VlbiBjb21wbGV0ZWx5IHNlcGFyYXRlIGd1ZXN0cy4gVGhpbmsgc21hbGwgc2Vy
dmVycyBvcg0KdmlydHVhbCBkZXNrdG9wcy4gVGhhdHMgd2hhdCB0aGUgc2NhbGFiaWxpdHkgdGVz
dCBJIGRlc2NyaWJlZCBpbiBteSBwcmV2aW91cyBub3RlDQpkb2VzLCB3aGljaCBlZmZlY3RpdmVs
eSBnZXRzIHVzIHRvIHRoZSBwb2ludCB3aGVyZSBlYWNoIGFuZCBldmVyeSBsb2FkIGlzIHRvDQph
IGRpZmZlcmVudCBndWVzdCwgc28gd2XigJlyZSBmaXJpbmcgS1ZNIElCUEIgZWFjaCB0aW1lLg0K
DQpCdXQgZXZlbiB0aGVuLCB3ZeKAmXJlIGluIGFncmVlbWVudCB0aGF0IGl0cyBzaWxseSBiZWNh
dXNlIHRoZSBzd2l0Y2hfbW0NCnRha2VzIGNhcmUgb2YgaXQuDQoNCj4gDQo+PiBZZXMsIG9yIGRv
IGl0IGlmZiBzd2l0Y2hfbW1fYWx3YXlzX2licGIgaXMgZW5hYmxlZCB0byBtYWludGFpbiAiY29t
cGFiaWxpdHkiLg0KPiANCj4gWWFwLCBhbmQgSSdtIHF1ZXN0aW9uaW5nIHRoZSBldmVuIHNtYWxs
ZXN0IHNocmVkIG9mIHJlYXNvbmluZyBmb3IgaGF2aW5nDQo+IHRoYXQgSUJQQiBmbHVzaCB0aGVy
ZSAqYXQqICphbGwqLg0KPiANCj4gQW5kIGhlcmUncyB0aGUgdGhpbmcgd2l0aCBkb2N1bWVudGlu
ZyBhbGwgdGhhdDogd2Ugd2lsbCBkb2N1bWVudCBhbmQNCj4gc2F5LCBJQlBCIGJldHdlZW4gdkNQ
VSBmbHVzaGVzIGlzIG5vbi1zZW5zaWNhbC4gVGhlbiwgd2hlbiBzb21lb25lIGNvbWVzDQo+IGxh
dGVyIGFuZCBzYXlzLCAiYnV0IGJ1dCwgaXQgbWFrZXMgc2Vuc2UgYmVjYXVzZSBvZiBYIiBhbmQg
d2UgaGFkbid0DQo+IHRob3VnaHQgYWJvdXQgWCBhdCB0aGUgdGltZSwgd2Ugd2lsbCBjaGFuZ2Ug
aXQgYW5kIGRvY3VtZW50IGl0IGFnYWluIGFuZA0KPiB0aGlzIHdheSB5b3UnbGwgaGF2ZSBldmVy
eXRoaW5nIGV4cGxpY2l0IHRoZXJlLCBob3cgd2UgYXJyaXZlZCBhdCB0aGUNCj4gY3VycmVudCBz
aXR1YXRpb24gYW5kIGJlIGFibGUgdG8gYWx3YXlzIGdvLCAiYWgsIG9rLCB0aGF0J3Mgd2h5IHdl
IGRpZA0KPiBpdC4iDQo+IA0KPiBJIGhvcGUgSSdtIG1ha2luZyBzb21lIHNlbnNlLi4uDQoNCk1h
a2VzIHNlbnNlIHRvIG1lLiBMZXTigJlzIHdhaXQgZm9yIFNlYW7igJlzIHdyaXRldXAgdG8gY2xh
cmlmeSBhbmQga2VlcA0KZHJpbGxpbmcgZG93biBvbiB0aGlzLiBUaGlzIOKAnGJ1dCBidXTigJ0g
d2FzIGV4YWN0bHkgd2h5IHdlIHdhbnRlZCB0byBsZWF2ZSBhdA0KbGVhc3QgYSDigJxzaHJlZOKA
nSBiZWhpbmQgOikgYnV0IGFncmVlZCwgd2UgbmVlZCB0byBkb3VibGUgZG93biBvbiBkb2N1bWVu
dGF0aW9uDQoNCj4gLS0gDQo+IFJlZ2FyZHMvR3J1c3MsDQo+ICAgIEJvcmlzLg0KPiANCj4gaHR0
cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19wZW9wbGUu
a2VybmVsLm9yZ190Z2x4X25vdGVzLTJEYWJvdXQtMkRuZXRpcXVldHRlJmQ9RHdJQmFRJmM9czg4
M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPU5HUFJHR28zN21RaVNYZ0hLbTVyQ1EmbT1nejMwQjRQb1dH
SzBVQ3Bnd3Ffak1LTDVMSHpNNnctNDMwTEFzU0VjVllnbTVpVXZDdUNLY2J2OGFtREhEQVV1JnM9
TU92aU94R01wSzNZa2dZbUR0Vkt3Z0pRN1JjU0ZUc0VBTVdVRDhXLVNvSSZlPSANCg0K

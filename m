Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF845ED35B
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 05:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiI1DP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 23:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiI1DPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 23:15:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F313D15737;
        Tue, 27 Sep 2022 20:15:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S1BHlN003083;
        Wed, 28 Sep 2022 03:15:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=tJvatbCbmbt69+boIwc7zgWgGryXP/2Almm3raEPi58=;
 b=EK2zTYwUaDWXLfHNx24Lk9QvP9NgfDITbS/vwFX3XFxY6BtrgEiN8OuIQwekwz4f2+KD
 h6PCIDUi6h1XT3UM1nYpbs1xKj4X8dvMQKRX/ORyhq5n4/NvWLJrES2b0bgTPuVhW06q
 U9jOfGFbMEX70A8gNosQEVS34EASSMnojlnp0w0F3ezAIpuUHefBrazokb9qEu7AA6bz
 Dw3RYd+lWjgHUYEPqjtlbaJgrsc1PQnYr7r8KN/zUE8Fjkvg6piuswLW1p3VzzBtuYaw
 gO/GqPvUJYIaQ58cBNfvcl+1wv1zEVen4GeKoabvw5XpLAoazfFw9Wzgtj4vE0TwaK7e 1w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwgjcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 03:15:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28S2RNXk019130;
        Wed, 28 Sep 2022 03:15:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvevrnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 03:15:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQl6MSRoykeff7Q4jaP0jCvh/wdcGt/3XLP4oexa3yW7kWNrnCMiuKndklmF3CpS/8RC2iaFM+VSp7E6oCeB80rDyaZ7DvSvU3guwWCgwicQiLFPQLWeFR8s4uErNCyhCFMkpD/aNWYv7T1qBi0YkPt27sCx0h+zUmJxcmrNXxXrzefp1xnvM+mx23Zl1VdiudsongtbzqLVobQ8UisnUvw3IbsEk48hz6ed2xeKMCKnaBW12/7HOuO0gakFIxzD+yEIXxz1O5hmDIit1my2r4a8nBZGCUrfn8ix9ZNJ6YwJGlWiN10VIe45VVIOWs0EXN6cZKp0Xbi0uBnjuRw3KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJvatbCbmbt69+boIwc7zgWgGryXP/2Almm3raEPi58=;
 b=QzlIxc/9BZAb6xArNyjLCHHVq2BSdNUDlZ5tQ/9cQg9VfaYuNxAqOC+8uE8DHAShFtOM8Rl/jsbzuhxscrRQInqcUrqF2W+6Q6aXIzVLow1OEUY1lMiw6Exx26g7nE6Nm42IzYHK5ByH5l6bQB14nWKY361hea91PTAPC66YwE2iVEBHy2zYPQ8TeUWHnC0zzovii9MB3FccI8ku9oe5onvPQFePdDhTlfejC35VSUEVkJ/MA0iJqIqlyCKmDm+16pufsD8RXeom7N9FfCPNyzOpUTTky05lV23+LjkqxqCCnNSh36UczuwT9siwdRZflkUWqkipdfQBDLwZyUHolA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJvatbCbmbt69+boIwc7zgWgGryXP/2Almm3raEPi58=;
 b=AASdstbGeejAGhCCsecaHcUWdkLTnWRWGczcqiEhbRZYJce3ND5tfTz6/MNb+g6Zl/qkxrs2l9cmLsBRO4gvFePp+7OJfE6OAvQVqKKSzLFqwYL4Av8dxFqiCd2MjGt8ao7NI6unmwkykAPHqYvXlARcSesRGQsuZEOVqoFOoSs=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 MN2PR10MB4288.namprd10.prod.outlook.com (2603:10b6:208:1dc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.25; Wed, 28 Sep 2022 03:15:28 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::95b4:7be6:3e45:d64e]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::95b4:7be6:3e45:d64e%4]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 03:15:28 +0000
Message-ID: <d02d0b30-f29b-0ff6-98c7-89ddcd091c60@oracle.com>
Date:   Tue, 27 Sep 2022 23:15:25 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 05/28] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220920233134.940511-1-seanjc@google.com>
 <20220920233134.940511-6-seanjc@google.com>
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220920233134.940511-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::21) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|MN2PR10MB4288:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a611c0-e698-4a17-a596-08daa0ffb15e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nJZHw116wRNqvHXAPZ3FDa2h3bA5/K6mImlEcTN0nSwcxXKQZeGgZMtMt74son+uwtMPGOphoNlfuuvvR/giJv5SgPLAbBiQm6ub+tfSvgg6SIf6PWs0R6b47Nv7aFZXVmYX9mLWUup+we182QCRA3vGXaKlvD7VNerwZHyU/T08MCslMEeKdMj54h8dvXPsJArf2j6GjaukKbhA4+icT8UZt428mi6lY195bqIt/sO3LKkHgHDKjK7hY0puYRortUQD8yP9K/sePFEd5r/JIu/zZP1PohTpYQm1EDNguWcIKIsouqW1N3XGNNbSHMU9jf0zmdv4XZMiFSNcIenNuryMop5PFnkbklZsymag20iUTu45m7fnsDd+DErYhoqpuiaAOFSA2hrr1D7M1EcSyBQiyKeRXPymvsZhJr8csFVm99ePGNNYMSYgbVxPbzHSkN68iMfj/EqVF4MoyvZKzvb1M2O6Ab32CApU6rnUIpVlJcWWuP4s7O5qFwZ6MoHhTDi8xGrXSBSm2avbil4+HjqaQDy8m0s+kHTO37ViWihUCy37pXK/bGVoghfpSBYcm5pnXbmGa7mYLGuhvAVvw3YXzMumM6g5cnbs9Pbjxjf4l16vg0NAvUsJQPYYKjxjyLB7ovYW0/7sw3M9qlhZLvAXBzShToOicPjudeZecPirjaVGOQ8qHX5LhPT30Oe7F6YaCWEYtpFsSMNTv4EMzkSTNYjNGupZMBIqIca+FMLSG8fExE4ZcYOsPWREcoXYpwrsW+Rotfp7CAOYOblQuBptS/fZFA9HYzMkxmzgCgxDN9lFb1T1BBxTbLRsnvRnNtGT98HAR9LSXEwAgBlTlICpuY31i3EC8MhU71+mOXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199015)(316002)(54906003)(6486002)(966005)(38100700002)(110136005)(31686004)(2906002)(6666004)(53546011)(8936002)(6506007)(478600001)(6512007)(41300700001)(31696002)(36756003)(26005)(5660300002)(2616005)(86362001)(186003)(4326008)(8676002)(36916002)(83380400001)(66556008)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uy9qMnI5dTRrYXVXQ0hLZFIwV1J0d3V1d2FrMUMveFFjNnZmVW0wUEkxMDZn?=
 =?utf-8?B?NCtoRlhNR2Vjd0NrM1hSVU9oKzlGRE9SRlFyWUVJOEVtM3I0bGpzdENwSXdY?=
 =?utf-8?B?R08rT28yNWZTWm5TcUFYL0Zsb1dEbkxqM3doelpqVGdrWFJxR1NhcS9Vb2Rs?=
 =?utf-8?B?UHJ6S3BYVHZuVGFVeStzY0ZaSjdoaFR5cUg4dE56YXBCRzhRVllaWHBPVENV?=
 =?utf-8?B?cEx1N3NTYWdjWFRqWGF5TUJmS0ZvNzBqbzM3aldoSXJZVUp6OVI4czVNOENV?=
 =?utf-8?B?VDEydk5UN1VRdEZjMmtueVZzdGR4d0VZeWROSlVwK0lNWkFzVXBDZHBONDlR?=
 =?utf-8?B?TGFTSmx2SVJSSHhIME1YZHpxZGlkVXB3aXg3cHJqZ1orZHJaYjF0dm5oaVBr?=
 =?utf-8?B?MXdNZ0kwRXJzM3cxTlpnR2tDZ3ZTaG1YQ0lwNDFMZkNVZENocnUwTG1TSzQ4?=
 =?utf-8?B?Q0hEMzdUWko1cG5iUmJtV3o1QUpNZ2xCZWJkeUoyLzFjTE40RlR0Z0QzQlpD?=
 =?utf-8?B?S2pOaHh0ZGpYQ0xPbkFpakJiOHJpVC9MaUlHUUJndlpGUjJnUzIwZE5wUW1M?=
 =?utf-8?B?OGlFRk84clA3YTc0OGpQa0VYaHhDYjJySzMyeWdXeGFhdlRKM2xMRDB1OWFx?=
 =?utf-8?B?OFM0bTlWQ3d6SWJ0U3RETmNIZTBmaUJqOVRvVVI1dmdpOEQ3RCtkZ1FHTita?=
 =?utf-8?B?cUluME94TUlWZzRnRG9NaFgxajhrNDJTUHJxMHoyeUtDN1ZERThxMkRnaEln?=
 =?utf-8?B?Qkhxa3hNRjNaVHQ0QmlNSDZTU0h6L09EaTYxZ0d4TVlwNzNSaDJRcUFvdmY3?=
 =?utf-8?B?SkphQytlNWFaV093R3FSM1ZIM3VXeUtad1JMR2dPMUJ4U1lKQi9PNUJVUVNL?=
 =?utf-8?B?ZFZCOStmKzhmbm1Mb1ZIK1BERWJpNzh3bmxMTjZsc2VYRDcrbWV0dW5aejU4?=
 =?utf-8?B?L1FVazh4S1VzOUc0VHJuQ2JLVlc4bzZxbVFweGgwUDg5QUpJdFB2cDhMU01p?=
 =?utf-8?B?UlNBWnBUd1VLQjBLc0hlZjlma1Zrb3RONzlndWViWnNGOG4reUpscnREbHpZ?=
 =?utf-8?B?N0dFS3J0aUZXZXJBU2hHQmZucHB5cW54WW5obTZGcGI4YUtVWkRydHNPbGZw?=
 =?utf-8?B?WVFVbk1BdFN3UWlCMVNHT1VxVDV6MURoK2tGS0Q3aHhubnRrTmIzUkd5K2Rp?=
 =?utf-8?B?N1BEOWJiR0t0Mm1Td2tJeXVMMjA4eUppWUdVSVRQTjdQZ1U2MTgrR2dib1Vz?=
 =?utf-8?B?ODd3YXNuWnluSk4ySm1PSysvSUlQK0xNQmRhUllrczZYOHh3eWhPUDQxNXpi?=
 =?utf-8?B?YVhxNEU1Z0wybnVpYkE0eWw1Vzhya21QNi9DMDZTMDQwL0RScUMxQXpuOEFn?=
 =?utf-8?B?ekRDK3VuSGN5ejJmNnZzaFVwS2FDRTNQRTlkSFFhdWkxZDJ3R3RpNWtOeFI0?=
 =?utf-8?B?WUQraVFXTXBxaHo2S3Y5aFd4TE9vQ29lZHRpNHpBZFRwdlNiTm1sOTQybXhw?=
 =?utf-8?B?WThkcGZBRlU3M1kxT3BZeUhZOWtYcWFWTysrMGJZenVYWXpNd01Bd2NRVjZu?=
 =?utf-8?B?ZzRTNEFrMXZ4Qm5SZi94Nyt4Z2lqNzZickhaKytBU2I5OGJxQUxIandXaTBI?=
 =?utf-8?B?WVdUNWpXQUJpRG9XMUk0MEFxSjB2MHM4STZycWtZdkNxSXcwMm9nbnEwSWEv?=
 =?utf-8?B?a2Z0Uk10NFpLcUdsalY1WlNjbmVRZzJHNk9USUV3MjR6TnVRbmhlR3duQWtM?=
 =?utf-8?B?NHNxK2lYdGZUZmw1MnpYRTUzZDRjdkRFWllxYUg4SEtaa1c0UjdiTDlGdm84?=
 =?utf-8?B?OWdzaFhvMzgyVkFoZWxjSVpTK05oaVROa2Z4YXlFeDM5bTlEaDJQUEJ4enBC?=
 =?utf-8?B?cnZJNGFyQVRkZ3VHcGJDTCtsYjdiL0tnNjM0US9qTjdqVDY1bmJOa204bHRv?=
 =?utf-8?B?bE1LdVlYT0h1SjNsY1NCRDNucE1jL1kzS3ppWHd2bWx5MmFrc0s2aFRtaUx4?=
 =?utf-8?B?OHNYRE1STklvVHlsYW9wN0ZZN3grazFrdWNLU2o0WDNFMjkzRFNGbW1aVXBw?=
 =?utf-8?B?Wll5eHRXQ0hUZ1ZSblQzY2YvWmJnR2V3VUN6Ny8xS2N6VXQ5VEtsNDBHUndn?=
 =?utf-8?B?SnpFblorTldPS2ZVbU5KT2g2U25PREJqWDhHRkFCMGVZZ1JieE05SDNpa1Nt?=
 =?utf-8?B?REE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a611c0-e698-4a17-a596-08daa0ffb15e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 03:15:28.1020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQTPYCPw0p9gwFf1fEWeQJC2I5GkTm6s3B4fS0uGmp+5jPitDZynV5jbhyQuJian6gtwjV6f+VTWV8kKVVGdv6wGppsQf8wpghp6VUFe1tI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4288
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_12,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280019
X-Proofpoint-ORIG-GUID: pZ_lqwX2KC2oTdeoAiod0EFh-2DgmNgg
X-Proofpoint-GUID: pZ_lqwX2KC2oTdeoAiod0EFh-2DgmNgg
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/20/2022 7:31 PM, Sean Christopherson wrote:
> Truncate the vcpu_id, a.k.a. x2APIC ID, to an 8-bit value when comparing
> it against the xAPIC ID to avoid false positives (sort of) on systems
> with >255 CPUs, i.e. with IDs that don't fit into a u8.  The intent of
> APIC_ID_MODIFIED is to inhibit APICv/AVIC when the xAPIC is changed from
> it's original value,
> 
> The mismatch isn't technically a false positive, as architecturally the
> xAPIC IDs do end up being aliased in this scenario, and neither APICv
> nor AVIC correctly handles IPI virtualization when there is aliasing.
> However, KVM already deliberately does not honor the aliasing behavior
> that results when an x2APIC ID gets truncated to an xAPIC ID.  I.e. the
> resulting APICv/AVIC behavior is aligned with KVM's existing behavior
> when KVM's x2APIC hotplug hack is effectively enabled.
> 
> If/when KVM provides a way to disable the hotplug hack, APICv/AVIC can
> piggyback whatever logic disables the optimized APIC map (which is what
> provides the hotplug hack), i.e. so that KVM's optimized map and APIC
> virtualization yield the same behavior.
> 
> For now, fix the immediate problem of APIC virtualization being disabled
> for large VMs, which is a much more pressing issue than ensuring KVM
> honors architectural behavior for APIC ID aliasing.

I built a host kernel with this entire series on top of mainline 
v6.0-rc6, and booting a guest with AVIC enabled works as expected on the 
initial boot. The issue is that during the first reboot AVIC is 
inhibited due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED, and I see 
constant inhibition events due to APICV_INHIBIT_REASON_IRQWIN as seen in 
the traces:

qemu-system-x86-10147   [222] .....  1116.519052: 
kvm_apicv_inhibit_changed: set reason=8, inhibits=0x120
qemu-system-x86-10147   [222] .....  1116.519063: 
kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x20
qemu-system-x86-10147   [222] .....  1117.934222: 
kvm_apicv_inhibit_changed: set reason=8, inhibits=0x120
qemu-system-x86-10147   [222] .....  1117.934233: 
kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x20

It happens regardless of vCPU count (tested with 2, 32, 255, 380, and 
512 vCPUs). This state persists for all subsequent reboots, until the VM 
is terminated. For vCPU counts < 256, when x2apic is disabled the 
problem does not occur, and AVIC continues to work properly after reboots.

I did not see this issue when testing a similar host kernel that did not 
include this current patchset, but instead applied the earlier:
https://lore.kernel.org/lkml/20220909195442.7660-1-suravee.suthikulpanit@amd.com/
which inspired this [05/23] patch and the follow up [22/28] in this series.

I am using QEMU built from v7.1.0 upstream tag, plus the patch at:
https://lore.kernel.org/qemu-devel/20220504131639.13570-1-suravee.suthikulpanit@amd.com/

Please feel free to request any other data points that might be relevant 
and I'll try to collect them.

Alejandro
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/lapic.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index adac6ca9b7dc..a02defa3f7b5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2075,7 +2075,12 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>   	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
>   		return;
>   
> -	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
> +	/*
> +	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
> +	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
> +	 * value.
> +	 */
> +	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
>   		return;
>   
>   	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);

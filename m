Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5041449FB0
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbhKIAmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:42:05 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38092 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232674AbhKIAmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:42:02 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A90AODW025578;
        Tue, 9 Nov 2021 00:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=li7x5nHF6yGtz/lFz8M1aUEtRQ0VfZEhh5TrIK0Yv7M=;
 b=aaDvz1Pl3ilrutSvepp0L9fz5+J4APC3y1++aP696AGX6oz9QM3i5EN8uK4revagumFb
 pVFje8RKJgoEZUNjQXdMmHGG4eiLwKp9d0XqjJK1hIspZ/Tg3lmm1fnJh+wB1uslXXxU
 J6S00DgJ/f4LjHl7F59VWXyM41Cd0hHXkblkYOL8YkVOtIid0TlUh6IQ5dlj1ucDh60g
 cuDBoUm0i6EB/IgCAMzFtnRzsGHwzMOtxSHH1TTzaEaO55eJXEnkOHb58toCWt9YldTy
 pPKY0BmzlL2cW8RLSx0l4OHB6LBYj80zSrqEB2zY4cbzWf15Sc3CsEjwh7mrLNTitCj9 VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6t7077gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:38:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90aEk0062799;
        Tue, 9 Nov 2021 00:38:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 3c5hh2v47x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:38:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4dhI6fsz19Iou9CPf+OAQhkQAKnYOgN329282itafMvPpahFlC9jW4ENMBpRKrmY9o2IfOpm0KSCyxL5FxuLoilvDvT5nhNNU22Y/Skn3Vx1cUEmcAPS3AabsVu7T+QB0yQOwtM7y9O6Ri9leqVCLMQoUfXIz3Nbsiw65TGN1+s2q7PfgKlWRb/HzajNaCIwLKOMomeYxzOPXOmeF+4T8JgQHWdL08kl20CpSSrca53ENKMFaY1yWCq3oHtnLmyjUYa5g1UULhq6/6Pr+e/P8vzOX3tckWRbrkvRsqHBuUurQ7V2RkFTfTylWCyWGm48X0461fM//bQPG2XtcpYvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=li7x5nHF6yGtz/lFz8M1aUEtRQ0VfZEhh5TrIK0Yv7M=;
 b=ibW5GCKNv2Jc2FyV4OBW6wL8kr9Xrf4eqY2jl/s7XDUfe9UYCG3/co4OpA0qFgbXNyMuc+2H8GHqCuRQM2TQ4VLMXaxCxuo93Kd3SVAFebvG+2CASDhz/SBlbPU7ZWTTP0ITjuXN93GGh1eJWroQSsp26st88d49Ekoqnm4ddTencxicX6AmtzkGLje2N/SsIYmGFgOXx5Cn/muVTKFz3FrPUziL76fGxV7IgHlF/rIT5/18Ved7soKwEsfGbm2t4mPZeaw8c6NSFFCkd2cVLFnHSHCWJelLVioMAV1mSm3pL1q1SngjUNf2Ky2L7kNLk4TF5tpzkytjvkBZAtAQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=li7x5nHF6yGtz/lFz8M1aUEtRQ0VfZEhh5TrIK0Yv7M=;
 b=wDpyJxQWfdEyvUDI7JBI3o/gk1UcguUBmd3ePw5elEXtW5gL+GQo4EA0WrSEJXfcSJjG1I35bKuzSuLYFc093GcL+5GF3Ws8BAx1/IejygOqdx+xrLR3R+1I/TKJWMoaUytI7BW2rbXCDNxiig1mUXb2GvmmdEv6aNd36ZaoHlQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4972.namprd10.prod.outlook.com (2603:10b6:610:c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 00:38:35 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:38:35 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 03/30] KVM: Require total number of memslot pages to
 fit in an unsigned long
To:     Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-4-seanjc@google.com>
Message-ID: <7bda9e32-3fbe-b5cf-f9e1-30b5c0b13f37@oracle.com>
Date:   Tue, 9 Nov 2021 01:38:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::9) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by FR0P281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Tue, 9 Nov 2021 00:38:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1f4b68f-1f98-4579-0ce9-08d9a319434a
X-MS-TrafficTypeDiagnostic: CH0PR10MB4972:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4972412127611987635E4D8AFF929@CH0PR10MB4972.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iy7zuUBIYazwQwAK/Jo+VwWQuXOd2/aDzBCm8wdVnu4WAr5xLNXtH++trWnx8dBENTj8Q/sDUVD4472TVVdn2Jy0fJRIxnah2a0mcl1+tIyXRZuSXWRR5Zu4b4UKfGea+jAvT5lXKtcu6PaoXFxcS/QeY7zaOftxjDLUC3N9VMGIJlaaFql3zyKsajQ0dPODAk7Easn/eJKqGMXbtvm26+l65GBc93eyamoi40bkvy9Kx4DoK7T1xA0AVJCJ/Cnvh4Vu9xtOTXZxsYp6bdiCiI7iUOMHGBSYv9RXXBx6O/fjLjQ/3TMf3mfBg46mZ3JEZlvM2E8R1ooDVXV+zvUxmH/EiEsAZ6cWZNVcJ4exkuvuHjUOWprt9j6W5Azjy/ZGnj+zXTapjXYuw8TgUqtOYQmez/hr87bhkSaK7ulXlPC8UUEeLW/cjoFkaCfrljDHHeUqPE8UCRHyHcvg4yUiqPHPBoU2QBLmZef4ON8/R4LxtXaVxbH7MdOhVSQBoql1XV2IUyPdsgPoZTKgHYTkn5PLFmZIoLqLe2uNjU0tHELaUXlDEZjfv2lt82pXSlXFIQZgcKq1x1HabPnRbqWYm8vdzqqpHiiX0LcdDM3+DZyGUAqWtlENyYgGQ+Mz8AfdaEktz2d8QpTxuUw9kMV2F2fSJZnPbPmWkTtsoVUfh9dVR7YWcx26RDzLqL6c6+IKgoBopdCbcTVpEvN5Bv9ngaxOuY43kUObr1g39CQMCtc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(86362001)(83380400001)(956004)(2616005)(6486002)(26005)(66476007)(8676002)(66946007)(54906003)(186003)(66556008)(36756003)(53546011)(38100700002)(16576012)(31696002)(508600001)(316002)(6916009)(8936002)(5660300002)(4326008)(7406005)(6666004)(7416002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnZOV2h0NE5hVjgwQW0wNkQ1dUNrWjQyU3RoUGRsVk9lcXJsV1NzQ1MvK1E3?=
 =?utf-8?B?NlhXaEsrMlhNTm56dTh6dVREdlJsbWdWa25iZThGTnFDR2Ezbk9HemdpSTRt?=
 =?utf-8?B?YzhJL2gyNEdCMjBOWk1JNnVGOWpvelRlaGtjTW42cEovbkR4NjNUNHl1eTd2?=
 =?utf-8?B?aTZwajFsbVRFbkxZdW1taHVqbzAxcXF0QzNhcHlYc1VJbGxRM2pEN1lGVFB2?=
 =?utf-8?B?eXBJMlJsdzEza2RuVGJSWGphVy8xRXJHYkhjc2ZRVndvbmgzNndRS0pjSDlY?=
 =?utf-8?B?SHRCQXVwMytuUGFEbFZkRDRUK1NISDJXL0ZWeGkrTjVscExhUStzWDJNNGFK?=
 =?utf-8?B?Y1dxcUxIVXh3Q3ppaFBQaVl4SFdZYk9GbkllT1h6MmlEZ1lDT3BNTlA1dXNs?=
 =?utf-8?B?c3JrTGxURFdJbGR0K2FwZXFFNjF3a2RNMG43eWF2SU5MRzJjWXdnVkZ4N3NB?=
 =?utf-8?B?Nm84TXFIcHJHRlVCU01rZE1hYjBpRUFOd3NTdG1xR0F5RkVMZG5tYVptdjZZ?=
 =?utf-8?B?QnVydmEzK2xCcnVTajFxL1VWMy8wODMvMkM1UzVjaGI5SElwL3RMdVVtWWtl?=
 =?utf-8?B?UmYxQloxOXFyZmVFLzFZcWN1bkMvVllMOS9KdXlMUVA1L1NQVVlBaHFXY1JI?=
 =?utf-8?B?ZHFRdGR1QjlPb3NvNVh6NVNlcTBibm1rMGpUZUdUaFg3WHlLdCtRc05ZT2sv?=
 =?utf-8?B?RWNDdnJkTm10S1ErWTZZdWVJK0UzREgrRFR1MzZnS1A3cUh6QTJ6TXBoUjgw?=
 =?utf-8?B?aUl2c2dwM2tJWFVGNXEyNENrUGMyMlpvTFlkV0hKQzlaUEhKcnMrSkNhbEF1?=
 =?utf-8?B?Z2ZsQU9waEhIQ2JUYTZqNHZkdXBRRmZaOHNETklpcnlyTG1UNTMvRHpXZnhC?=
 =?utf-8?B?Qk5sSlBlT3Y1UUxaN3lHblJvckVjNU9YSWtrV3ZoclVoZEI3VUx6cDJUT3I2?=
 =?utf-8?B?SHd6WUJqdzV4M1NuMWwzOUFSV2lVMWJHTFQxVHRNSmM0MHhwQ205REhyd3Ri?=
 =?utf-8?B?elVib2ltM3M0UzhpYVJvSktJdTdkNFRRcXFWMW8wUGtjSGowQkNDV0tFcGc2?=
 =?utf-8?B?b3hHcWNUVXdMTHlCbWNYVDlGUStxaWpiVzRBUkQ5NUYwc0Z1ZWI1WFhiUzdM?=
 =?utf-8?B?RFZ2Q2I1blNLQjljZ0VjaHFGbGNJYW1pR3BROWZKd0RYa3c3djlaLzA2VHJK?=
 =?utf-8?B?NDZUMkZrd2RyV3k2alBEeTZmcnQ5SlZIZ2dNV1hzREdGZWQ1aDlEbmxVaXBB?=
 =?utf-8?B?d0xvM01KeFNNUDJsZyt5enBvNEcyc2lUMWRDTGdLTWFlMVNuYW1xQ1J5Unhz?=
 =?utf-8?B?UWpJSzlVSXMwaXhORGRQZGx5Q3VYSnFyL3lCcE9sM0F2czEzeDVTMEpMNkpz?=
 =?utf-8?B?OTU0YkZZVEdpUFcvblY4NkM0QmRNeFIrSGU1VTg0OHV1aUhBc252Qi96Y2dL?=
 =?utf-8?B?NmYwalcyeXUwQlBkNzdGUmw2MTBxdG81TmlYNnJxcWtBa1VxZDBYREpSSUpE?=
 =?utf-8?B?cW9oeE0yOEY3SXh0bk1zS1lON0t1Z01Ga2hkM0hJZjVNRk0rYWpTR0xJbDJI?=
 =?utf-8?B?MXBMcmo1aEZ2dzB2bmRDZU9leXEvVlg2SVQ1aHh3ZXl0cVV5TmNWVFhROVNV?=
 =?utf-8?B?OTB1Ry91MFhRN3FVZFNHc0pCME5tSnpjZ0xwNTdjWU9Yb3lJVjc1R1kzV1FI?=
 =?utf-8?B?SjhGcExMOExnNEJrbUpOc0FVMlVtaWRBNk1tdGUySk1jdE1keEJMSS96TnlF?=
 =?utf-8?B?MlFTSVgxYkcyQXZURWdSTkV3bTYxUVJ6eTc3anlIbnRTMTJReU1TalM0RGdV?=
 =?utf-8?B?NTJXZ29zbVBoMXQxNWtJcTZpRmNVM0RCdXltTUkwK3pwSUVPemhxZUxOeUpB?=
 =?utf-8?B?VnZCQ2VGWXAxcXlSQTdVZmFyUVNZZmlWcEt6b1lISnJNaklSLzdiUTNqWDRz?=
 =?utf-8?B?dHV6cityNGl1N0h4TUhORXk0R01LOVpPb3U3dGtCTVRlR0lWeENDTDhYZ0Vs?=
 =?utf-8?B?WVJiTFh3YzQrSWxWbU1kdjVZWW5xazVLS3BrSnljVm9Xc29PeGZuVythVldU?=
 =?utf-8?B?RUxNQjVRWXRuOHQ1OXVKekJCS2Z5cXFXU2Z6dXo2K3FFa3JFUnF6YkhvTlNo?=
 =?utf-8?B?UjdFQkk2aDNaMVAzb0VKa2ZURnNDeVZONyt2RG9UemxkK2NWNGFBSXd4V0lD?=
 =?utf-8?B?SFgxaW5HSDVXM1Q2Q3dqU2RTRnY1NWQ0MmU2d0ExZjdlU2dCR0xnV012RGlK?=
 =?utf-8?B?bVRhcGhWeDRWM3hPbmNEKzJCY2V3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f4b68f-1f98-4579-0ce9-08d9a319434a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:38:34.9531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wQ5tUrn2Fl9cBAGfCo98lDZBODj9j02M1uWV5UeS5CQQCooB1m84Bm9A7v4p4l4C9jQ2x8uEs2jN8oYUAgcjynwQfcyzapkjjFOOou6XF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4972
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-GUID: G1dhgJfhXaRS9F6saRtmZYTyfypIbHnr
X-Proofpoint-ORIG-GUID: G1dhgJfhXaRS9F6saRtmZYTyfypIbHnr
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Explicitly disallow creating more memslot pages than can fit in an
> unsigned long, KVM doesn't correctly handle a total number of memslot
> pages that doesn't fit in an unsigned long and remedying that would be a
> waste of time.
> 
> For a 64-bit kernel, this is a nop as memslots are not allowed to overlap
> in the gfn address space.
> 
> With a 32-bit kernel, userspace can at most address 3gb of virtual memory,
> whereas wrapping the total number of pages would require 4tb+ of guest
> physical memory.  Even with x86's second address space for SMM, userspace
> would need to alias all of guest memory more than one _thousand_ times.
> And on older x86 hardware with MAXPHYADDR < 43, the guest couldn't
> actually access any of those aliases even if userspace lied about
> guest.MAXPHYADDR.
> 
> On 390 and arm64, this is a nop as they don't support 32-bit hosts.
> 
> On x86, practically speaking this is simply acknowledging reality as the
> existing kvm_mmu_calculate_default_mmu_pages() assumes the total number
> of pages fits in an "unsigned long".
> 
> On PPC, this is likely a nop as every flavor of PPC KVM assumes gfns (and
> gpas!) fit in unsigned long.  arch/powerpc/kvm/book3s_32_mmu_host.c goes
> a step further and fails the build if CONFIG_PTE_64BIT=y, which
> presumably means that it does't support 64-bit physical addresses.
> 
> On MIPS, this is also likely a nop as the core MMU helpers assume gpas
> fit in unsigned long, e.g. see kvm_mips_##name##_pte.
> 
> And finally, RISC-V is a "don't care" as it doesn't exist in any release,
> i.e. there is no established ABI to break.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

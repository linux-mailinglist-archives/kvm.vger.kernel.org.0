Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A63137FB2F
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 18:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbhEMQEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 12:04:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39376 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbhEMQD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 12:03:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DG0VQu189607;
        Thu, 13 May 2021 16:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aZl0X375NKdi1MwNUSDSmTc/kHhRQX2vRKBuqmOcoG8=;
 b=N5jQvTVsSrn7MznzibsowzW7N07SOYruz1DVpEn0Y2AAAJnrcwoAQv5WHgQ9ec0IObun
 GWg5CTbutxvE6BZplHpM3g60+zw3V0sqaLGJfLMAo8eWPZrAqPDd4EhmtWTM44JxIYF9
 EiNT+cl/t0W26w6KMuWZU/OZkg6jWknx8JYRXhZuhTrQHJwQRERlSQnV9JLb6KJPS10p
 K/aRtIU8bpXlU+QyP1y6aRSkWGOfSwdYYEhSuOqDBWlsNZ2BLglwpuTcN8Dpn2zvYvkI
 Ag7SUf9QIHHZvKP4zKSIL6cOSv5jkU90yxBdkcXA2VAV+XiaqSHhhY+Aea+hEGjIKMek 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38gpnej4jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 16:02:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DG1s0i151838;
        Thu, 13 May 2021 16:02:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 38gpq257g9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 16:02:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWVCKZIAmmz0ttPPnCPPLfb4N5WUpKLviMa5GPNUotJ2hWxgFVDDMHrd2lKbbKDd/g3X+JjaBZjcctBLSkwmy7xJIuOelMy6z1HBj3tiEXaEXtaT+lJsBUX+C27yGV3J3AG+VP2jnudPFlszBIE/oGyS9QfGAL3A/eCfzHS92YwpUBWLbi5ezcUuxoUzUSsxMwKN1S1BEeydax2V1fp+C2LLHVNOLEFyGm80A+/5WRjkzbCo3d8c9NwVT1umhqeP/SrA3PMh9/Zj7s2MKwdB94f7FzZIQyeb2Ck6/r7eWZkSTePaq28YFmfaMQ0yRl4dTC/HX91124fOiIq2+MkKfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZl0X375NKdi1MwNUSDSmTc/kHhRQX2vRKBuqmOcoG8=;
 b=S+hCSXFQXpt2YvGqBB8x/7w26RtyZ1JL8E4GFIcRGqG+z7iM2r42nuu1qRDtXHvAKFxYmmc1N9udPTUaHCXGDP5mWGIR0rhrGAF3dwVpFGcfolxc50jLhoOy2xrPZq6wg/A2zENp/6dcLn47mmDfIabpK0XX3DmVbLfJv5/F2+/oggUPV3Z5OiEnyRFlECQ4yn0o2fby2LWiu8W533Yh+/Hq1Nwu/EV2BRP7JMWJuI5fTBhB7Wy3WQkJ3TT/bCnGn/UsSdzjVMhuRfx/utCQ4CE0uThRAj7ISyqW/snSVfWwWyBAu0o6p9Ogd3Q3o7IdgOCicZhi2Ri+rxy4a8FFaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZl0X375NKdi1MwNUSDSmTc/kHhRQX2vRKBuqmOcoG8=;
 b=hpNEvZNjfMFBD3Qpkmnf0U5ZXPiuSuKqi0WHWTTQl2dRXqs5bHkPJMyUWyQIf4QZtFjcLFZGA8509iY20Pcm2Rfe9PvY4h4IXXM3SgSOuO4ccQ63by0U6FSmtQ8+tNJ05zH+ZY6i0X9gZOfL+7AgXRnGU7KjmQ5xzh1Rj0Bw2yQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 13 May
 2021 16:02:30 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::18a:7c1f:bf20:ba6c]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::18a:7c1f:bf20:ba6c%3]) with mapi id 15.20.4108.031; Thu, 13 May 2021
 16:02:30 +0000
Subject: Re: [PATCH 1/3] KVM: nVMX: Move 'nested_run' counter to
 enter_guest_mode()
To:     Sean Christopherson <seanjc@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
 <20210512014759.55556-2-krish.sadhukhan@oracle.com>
 <YJweqOAxMITSmKs2@google.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <ed4a8dae-be99-0d88-a8dd-510afe7cb956@oracle.com>
Date:   Thu, 13 May 2021 09:02:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <YJweqOAxMITSmKs2@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:646:c303:6700::991e]
X-ClientProxiedBy: SN4PR0501CA0120.namprd05.prod.outlook.com
 (2603:10b6:803:42::37) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700::991e] (2601:646:c303:6700::991e) by SN4PR0501CA0120.namprd05.prod.outlook.com (2603:10b6:803:42::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Thu, 13 May 2021 16:02:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59963cfd-a614-4502-2c93-08d9162882d0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46069FE7074BAD0B33D7ADDEF0519@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9mDdqNMOVMb6vNRCXjrzX2t/qSz3cSeWco5HA/6wKuaNPvv5LeNsdskZJ95VmCGnGYYQudS/0XxA0n2PtXoFLhdOwkawzhzzzqw8HnMwMLgBBPFTu737exW19lY9tfSNYzPEEn2lpDO7BcLBilGJylaxRw7hj6pDawaMPDEEkBlA75Fzy1F4THbIh9KfitgzuA/9MNL8Ge4A8U/ER61PJnn28L2OjeBDZ0+1N+R+Ib6FzKTu9LQT4sAX5KYqEhRui47G5Y5mLCLDvRWXWELNQKWZRA4XNxKyuHMDgzzQkarXQuHbd8+p5IyPfiRa2lRD7yLBFmfipal1/8UdJi6wzZkVp2QrmeS4ywTcJ4Mcq/qMd7ZWl7Uj1e73a/SG3616INXiYe7IB7RAhJgh5m1TNr3oqkeFISoHQKGR24z6fAUp4LNVecJ5aaGCRXTW/xiCsezCe0Y0pzu7+egu5pANLTKfsuIMHmdY+7hvNDgvyF/b4a4pCMf/YHFJc59F64d1xC+X8CVkCvijwQWiEWzIYHXLVJ9MT9lmKk5thRB7iwvHqugywK8nX5Frqz6DclQJD30a04a2/1aX07aE5S4Kz218+b58m3msXWCXiuMR4Vq9s90kWB/cUNke4it6Q1ZKJT5qKLUZ2Z5nQTisOJKfHh+B5RYwpDgi3XUmOw9RpKeR5g+Gw36Das1LPpab0Cy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(346002)(396003)(6666004)(8936002)(186003)(44832011)(5660300002)(6486002)(66556008)(66476007)(66946007)(16526019)(36756003)(31696002)(31686004)(316002)(478600001)(8676002)(2616005)(6636002)(53546011)(86362001)(110136005)(4326008)(38100700002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TjgwbGNJRER1c0x3S1h3M3N6Q2lDQkt1cVg4NDkrQjc4NnZrKzZVVnRpWkwx?=
 =?utf-8?B?STNQUUJ5QXVQUWdSSHhDdGNWUDhpOXNQbUwyWjNXWEQwdjBUeEV2ODdGQmNB?=
 =?utf-8?B?bU4yM1V5ZFhTYkdtZXFOb0MyeEJzWWlvaU1KcjVyU0Z3a2R6bjQ0ZVlxTXA1?=
 =?utf-8?B?WlZXS2NYT052SlZHYmQzZnd5WWg1azhGT0VGektubG8zRlZvbS93MGNEYktl?=
 =?utf-8?B?d05JKzVMNU1hanl6MTU5bUlsSloxRldacHA1bmwrekJCSWxjenVtWW9lejNP?=
 =?utf-8?B?RHI2bkNQcW5rWEJRdU1zRm5Gc0FIeWNldUhoNi9lRzFhZnl1R3lIZk8veFdN?=
 =?utf-8?B?UUwvSy9NelZNUU9neThwNi9JbFp5RGdMbWhlU0hxblJmZ0hQc1ZYNUprbkJY?=
 =?utf-8?B?WnFXcFZoUHhLR052eERFL0ZvR1ozb3RuWllxVXBoOHd2djVGNWJ5YUZFNCtE?=
 =?utf-8?B?YkxvYjk1Mk9ydkp4SnNNL2FmdEY5VWtBTldia2h5QjFlOEg5Wng3cDFIbkJv?=
 =?utf-8?B?eGRUTG5TdHV2cy9SMWU4d0piWUVtOXE4TlpYRG5naEQ3V1NXVkg5TFY0L04r?=
 =?utf-8?B?VDU5bHFERWhTei9sL0Jmc0xVbU5jZmlHTDNBdDUvelh2Z3Q5dGRyRCsvM0FY?=
 =?utf-8?B?TFJGS1hOQVl0SU40MUxzWU9XejRpUWlHZFY1OElEeWFHWnR0K0paY1RrK1BZ?=
 =?utf-8?B?S3ZiQ2xHQXRHNDlDbHRJVUhJeWg0T3NaMFNDMXI0ZzFDT0ZNOUlyNlV5ZW5y?=
 =?utf-8?B?a0JKMnQzZ3VCTWhxRTF1WW95eXpyc1F5aTAyTVFsU1lsVDh0NjhzUm9QZzNS?=
 =?utf-8?B?bWh4NXNNbzhacDVYMmtoRUdadmZxL01uOWNrMGRjenVNdVFPWFNDbmdFckM5?=
 =?utf-8?B?dUZZaE5KT3puVWYxRkg2NHpzU3E0VVoxSk5jVU5Eelo0TFh6cFZJMWlkV0VD?=
 =?utf-8?B?L0dZOHNKRDAzSGZGdEhXTXYxYm9kT2cvSHVFTU5maGtvM2lWblVheURFNzkr?=
 =?utf-8?B?YnRzZTczZzN1dW11WjZZeFk0SXIwNmV6am9hbFNld085aXB0N0xCMUMxZ0l5?=
 =?utf-8?B?SC92ZlZVR3IvQUNPVy92MXAxQUczQU1aVG9CNnhCVW9iVk4rNzVuVFlqcTlW?=
 =?utf-8?B?L3huTzc3YlRPT2pLbWxWWmlxTGdmMTFSNE5ZL1dtK1JXZCtCK1JwSFpxMmdG?=
 =?utf-8?B?bTR4TzBNZ3d2TjkwMzYyK2VxMTZtTGNRVGcyVVl5K2R2T3lKT2J0N3E0L0Ez?=
 =?utf-8?B?MFVIdWpJMnEyUEVSWkZKMlgyMk9XcDVsQ0E2b3lTTUlaQTVCTzZucnF5U01m?=
 =?utf-8?B?ZSt2S1FFVHZxbEpoSjdOQ0Z5QTZON28yMkpJNjZaUTZ1YWFDQTlDYVpzL2JS?=
 =?utf-8?B?cGtHQmM2Sm9HbXBQU2NQblppSHZEcmRVNjMzczE1Zk81aDhMWjJwZk96Qk1T?=
 =?utf-8?B?RysxS3VMQmFiajZXTGxhQzZlNzVBVjBzOXZJaEtsaHQyMTBpZDJkL2JmejZI?=
 =?utf-8?B?a2xRRXJ1WEE2K2Vwc0NZWlJwdEFQWEl4N0dTZktSbHd2Vm5BMWEyYUZEN25Y?=
 =?utf-8?B?d2wwek02MkZpc2lyNEd1SmZWUUJ4Z2xjTGFTTmJ2OEVqeWFIbndpNWpyQmdk?=
 =?utf-8?B?SVQrWmJSUnQ5NlE1aklUc0w2MkxMc3dQZThCS3VDaG1ycFUyNWh3dFFNZDhs?=
 =?utf-8?B?bkQ1blFnWXk3U2kwZjNLTmFiT1VFaG5QbGdwOHNNZ0RtamI0cHk5SkczYjIy?=
 =?utf-8?B?SU1YTWpPZHZKT09qWDlRTW9vL2pBdC9RZ3RMRU9qQ0RtdkNhcXBpb1BFWVBZ?=
 =?utf-8?B?V2hMT3J5YzVqNEFNS0diUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59963cfd-a614-4502-2c93-08d9162882d0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 16:02:29.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOATawhAGMiyinKDbsTm2Z60ZbWk3k4MP2/soM9yGF1gXWv/y0EvzYi70zhtU/qZgGoFiBBvdcokKvc9YR88Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9983 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130112
X-Proofpoint-GUID: _XsV4yyqUCAOsivrT3T4qU-Jad48uthG
X-Proofpoint-ORIG-GUID: _XsV4yyqUCAOsivrT3T4qU-Jad48uthG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9983 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/21 11:30 AM, Sean Christopherson wrote:
> On Tue, May 11, 2021, Krish Sadhukhan wrote:
>> Move 'nested_run' counter to enter_guest_mode() because,
>>     i) This counter is common to both Intel and AMD and can be incremented
>>        from a common place,
>>     ii) guest mode is a more finer-grained state than the beginning of
>> 	nested_svm_vmrun() and nested_vmx_run().
> 
> Hooking enter_guest_mode() makes the name a misnomer since it will count cases
> such as setting nested state and resuming from SMI, neither of which is a nested
> run in the sense of L1 deliberately choosing to run L2.
> 
> And while bumping nested_run at the very beginning of VMLAUNCH/VMRESUME/VMRUN is
> arguably wrong in that it counts _attempts_ instead of successful VM-Enters, it's

Yes, the original purpose was to track the attempt. That's why the counter is
incremented at the beginning. It helps tell if there is any attempt to run L2 VM
(and also if VM is actively running L2 VM by monitoring the counter).

This helps as sometimes VM owner does not realize software like jailhouse will
involve the L2 VM.

Without the counter, we may need to temporarily use
"/sys/kernel/debug/kvm/mmu_unsync" assuming shadow page table is not used by
host if L2 VM is not involved.

Dongli Zhang

> at least consistent.  Moving this to enter_guest_mode() means it's arbitrarily
> counting VM-Enter that fails late, but not those that fail early.
> 
> If we really want it to mean "successful VM-Enter", then we should wait until
> after VM-Enter actual succeeds, and do it only for actual VM-Enter.
> 

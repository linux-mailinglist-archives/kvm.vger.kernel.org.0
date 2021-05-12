Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CB237EBC1
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 00:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbhELTgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 15:36:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbhELR5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 13:57:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CHocZc164414;
        Wed, 12 May 2021 17:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Q5jBGEc4gMxm1oDtwvq/JhPZ9S3nsnDPb93L9wL8JPY=;
 b=gzfvuxX9j4m31vo+9tBj9Y66WHhEdOOl9GUdxpCQnWv9hM2qNfS60ejC8H70+SzH3TQ6
 X6mbg1QW3qaFlj3A+DUGDcixsR5KoscAUd0gykQbpXxYrPCZCeyLAXnH71otz6RHjX6u
 06lX+5GQzIldUS0P3WY9idhtyeSTn8DatPyqnobmEDz8ZXG2/EYWg6CvswMoazUDVBJG
 FYVCTN+jBQoYNpa1Ire1ir70md3akB+obwyGa2mOs4QFAB6+xHcysZxmCE8EAgIzFdVe
 EYD9OsOH8FPt5CHXe80OEaRa5HRw/RPGOpvxms7Dwb2jpxZYAx3b6vqL8KnRKxmJUEJx 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38e285j4jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 17:56:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CHtemH064573;
        Wed, 12 May 2021 17:56:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 38dfs02c1s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 17:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoJjKMK/jKrACn/vsIMSdwJgjTr9rf3/QgMKACJkm3PEiyRJa4mZ02Unsg1wFSoTwznT5t6P6o4cBwimtTpN5ecGxOSOwakoFk7e2shd3qadUdCvN19T9xgTdj+rsh/oRXV+EC7goKPSMeorILR/I3fXQQzZcaVF0sxPoNRt7j5oBFePieg1ynsBzxDhoL/wZucC5v6b4VxRCFwoPL6S00tCP2BADVT5PzQ3N9nMDCry0RiE9mLPIUtVBf6aTRxyKPmzeGHDmVj8WKHRjGeKqZEUIztn30Efy6bRTzjBQGmrybdopiAXqU6njMXL9RJBOEf/3qQpI7MIQ+VahG9wgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5jBGEc4gMxm1oDtwvq/JhPZ9S3nsnDPb93L9wL8JPY=;
 b=BbVEQZTn1yWJsVUVtJ9krVQesZ0046dySGP78jJRhuVG8Z1/d4dF/c/DG9r4yNYccWGajc5y4UVcw/7dir/01NecbcWlAMFFSc1YxT1cB0mXuMMGrs8Sea9lQzGVntwZtCjGhsTamms4AxaKTU/DJ854tAjFqHk8mZYcLWBmjZk32Thkjo7deBEFD6mM3tuGOxkVTEnpfQqHOmAA7n4tKky1QLGIsKVbauYrxNCql8mN5Eps762umt3H5PJIxCE5n01WGtyGugNcfs2Bvjs8dccqVFE0MAmS011OixE9gHnoi3FJF110tBbUGWHsSLfBoOzXIaYSWem6Lt7f9KWWeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5jBGEc4gMxm1oDtwvq/JhPZ9S3nsnDPb93L9wL8JPY=;
 b=vAkIxsv5Rs5vQ5lRtMTmEWAsVEGf6I1UXNJGDY2GI2VD75hGcPCpl9pI/6WAcp6xYXjvB+c4IGlTZHolPVwXvh9cZ2vHJeSohY5HcmSFSMR9UmYKq9jetClATyuwRLcJj5SorqyqbEhAKynD4Wy+/Pt+ja91cBcThDQ44sAsCaM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4522.namprd10.prod.outlook.com (2603:10b6:806:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 17:56:16 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 17:56:16 +0000
Subject: Re: [PATCH 2/3] KVM: nVMX: Add a new VCPU statistic to show if VCPU
 is running nested guest
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
 <20210512014759.55556-3-krish.sadhukhan@oracle.com>
 <CALMp9eTCgEG=kkQTn+g=DqniLq+RRmzp7jeK_iexoq++qiraxQ@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <c5c4a9d2-73b5-69eb-58ee-c52df4c2ff18@oracle.com>
Date:   Wed, 12 May 2021 10:56:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <CALMp9eTCgEG=kkQTn+g=DqniLq+RRmzp7jeK_iexoq++qiraxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [73.15.199.204]
X-ClientProxiedBy: BYAPR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::16) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.15.199.204) by BYAPR05CA0003.namprd05.prod.outlook.com (2603:10b6:a03:c0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 17:56:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b458d61-a36b-4262-09b5-08d9156f3d5d
X-MS-TrafficTypeDiagnostic: SA2PR10MB4522:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4522BAB3487E47C9C108D42681529@SA2PR10MB4522.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oIqDc0OfwX0eisIRNXyBD4sSzwNPP22duBiaNR+TR2QV0vUQT6cJDKLN3OnJgLbEsaP4dWKgV59MvXvsGAJvBpI3yd46KH3eZRHqhEXh4sKf7KoUoq82lxg3OnNpcFN5rAjbLO4BDCE4ltQbmd/nlA1qJyM2yUYWsoM0Bjt6HyZDx5nV1p90rm0daizBBAVIy0zzBezRGLPKzx3TBdytnsUz/hWymVSkF9ScKOi/6flVEGhxXJ9BzLpSRAd/yyW5Tdu3RHVh4K/TkBJYWK81jnfa0BVXsYyUeXl8doKOH32dw2x0fZDnE+uRqvxxTaoMQkYgOc3NauDhQbzc92IDoXNoMNEinvDcHpy8gsoiLldFDhzXj0vYCbOmJcr0lN8oUOTVqtHUT6CtT/8hPCLpZd58acKbAs/az5CpsZ7DzS7N8DWuFzIUrTqne2cAQjeb1iGU4WfhMezGkOHSZP1yJq0iU0Xb3ikl0dEDgzfvplQ9MMKzvSTZAAxiJUDql7uFfdR5ZuM3UcQc0E9prQAAssRzpXf8X0GpvmmvRUySaq35WpjQwMXxUoQ8bjOaC1zfuXQekpsTAKklIpLIAeOv+L5fEdANE0uj6Zz6Z6yuX+n6vdEa6Y03OcNHcMFktetaXykxov2mWlrKE+jjEiivSzvh50pwk/3sTCzO71WS546bRWvaFakq+O5t0+seZoNi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(39860400002)(396003)(346002)(6506007)(16526019)(44832011)(26005)(478600001)(66476007)(2616005)(956004)(38100700002)(4326008)(6512007)(6486002)(66556008)(6916009)(8936002)(316002)(54906003)(2906002)(66946007)(53546011)(31686004)(31696002)(86362001)(36756003)(5660300002)(186003)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VlFQUGh3Ly9vZVZhdkNDMi9mdXI4Ni9FaHJhOVBpVEZBc0dpNEdZaUhnL2JS?=
 =?utf-8?B?RjNtZ29iQWkxbjFyTWF6VnJCK09ERXRxQzVjeURZOWhOcmNNTXJKVHB6Rkho?=
 =?utf-8?B?czdHODgvVDJZd285Y0JZUjUvRmU0MjBqUm81VTYvRWlLRjN2WmJsRTJBZDlX?=
 =?utf-8?B?V0w5KzhTSGJvVEFFaWRoZUJUQVZJRm8xSkJ4QW9QR05FOHNyVDUxblZsaEJL?=
 =?utf-8?B?R01BOXFZaDQ4VXYxdkhpZ2ZmVC9MNmlpZGM1UGJOZXhpeEkzUGpYRlFaemdT?=
 =?utf-8?B?dmtPZzJUMHlXdlV5Vkl3REVNbE4yMTJlYnpuVmZwTWZnQjc4RkZCd21CNE5J?=
 =?utf-8?B?OERUYmhMd3ZQZHA2eDNpVytRVFFMbmIxbmdBaUMwU2tUUU11MnZ3MWdEam84?=
 =?utf-8?B?UURGNjFZMW13SDhhclJRTTArckZ0MGN5aCszV2NIZFU2ZGQwWlcrV3NBNDRN?=
 =?utf-8?B?Q2piN1dqWm1BYkpYUlM2N2RHZzhDRTJKb2I4b0N3ZzJHczlCeGpxVVFJWnJC?=
 =?utf-8?B?TWtaWUJxV2UyUVNLOXNHT3dDV0xZV0huOUZGMHJYQUgvTThmdmoreWE5Sndk?=
 =?utf-8?B?MlFJMisyZDdUNklKZkc1ZTExNkpzSHd6WEZyd0U0bGVEUTRTTmlZeFFJUysr?=
 =?utf-8?B?WHF2WjQwekJ4TEx2Vk5QSnBsQ3g5b3RMMGtYYnIzeFVzRGg1UXFuaGlxUEhw?=
 =?utf-8?B?eVZoR0pJNWc1SUpid0p0SG55cUZuRW93ZFk0UzAzY2lOcUFja3l5YjZEQ1gz?=
 =?utf-8?B?Ylh5dWw3Nk1XdDBRelVadTBWUk9tdCtDTDFFc3lWa3AzMitTcVRYN0U4YTZp?=
 =?utf-8?B?ZFVkNy9RcEFFbE9peUpuYkJHai8rVHNFUXArWm91eUNIMzAzZ3JocDdEUHJ5?=
 =?utf-8?B?dEV1ZWxOQ01wUVlIamJJSW1PMXRNM3FUU2t0WnpSNVpxeGUrMkYvbWY4NWJ2?=
 =?utf-8?B?dlF5TG0wbFJFeVZYWVFZSnJWK1NhLzZRZFJ3VkYwMzF0ZkY4M0VLS3ZEbUdY?=
 =?utf-8?B?bnRZRG5NZmZaVXlpNEp5a2FBTTh3cTVKdW96T293Nm1PcVVmS3BjR2hzUnFw?=
 =?utf-8?B?TDRaQ1hlLzBteVNIYzBKWm4zd0daT3h6WGR4SWdvMmhtL0ZiSzJ4cjdHOURV?=
 =?utf-8?B?VVJCOENneXVEdkdscmlqL2lSakQ3ZEhKelBsaVBBVmUxdlhiSHRISE54V0RI?=
 =?utf-8?B?T1p2S3VUR2JDT0FObFl5d21TSzdlMGNvcGNiNjVtY0VrcDJ4OXFIaUJZZU5a?=
 =?utf-8?B?cXhqalR3Tll2UStkUW5hVis2byt3K25oRFNqcm91YWNEUW1RRE82cTBmSW96?=
 =?utf-8?B?UENaOVVnUkkyQWM5VUpGa0JIdTFSVVVRMUoyRitLamthYmJ0UFdpc1J5NTRm?=
 =?utf-8?B?NVZVUVE0QjFPWTVZbXBML3ZnT1ZrZzczUEt1bk9OZ09EY0Urb0x0UElsSldq?=
 =?utf-8?B?NUd4RTczbWtIS2FWWTVYRlBWdFc2RzBXbGxSdS9OSEhOUXRBeDBFWHVVNHow?=
 =?utf-8?B?aWdRRzJONktKNEhUS2NNcjFCdmExRmFlOEZMMkd1eWdFblg0K2szYnV4T0g0?=
 =?utf-8?B?SHdLN0trUzdTV0pOMnZyZmV6dlFBV3IrbFU4ZmJDMU0rZEtLWDBaWXh2b2hs?=
 =?utf-8?B?Q1ZqWVVWU2lQT0lXMEw3aE50QjJ6QXhDVndlNjN6M1BObWh0N2Q5dHNqNDk5?=
 =?utf-8?B?SEd6RWYwRUxMK0txdGN1OUJ4Y1hYbXQwVTVoeXB4RHZXc2wyRm9LVkFNRFZo?=
 =?utf-8?Q?ANkHyP5H7xx9vFFKjw/A69jPhjUmF+x6QDJuD2S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b458d61-a36b-4262-09b5-08d9156f3d5d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 17:56:16.6335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEvdW8StyxAEWKTTEUQ2yNBAWNNK5DRzTQlNr4KJuPLWeLb8xXSr9sKLSoA3fVsR00tGP0Jt72PLkRl6PwkfSDxIIwdd2b28rpl1xfTHGCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4522
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120117
X-Proofpoint-GUID: 8UyReHqqjqkXftduwHPkp3yvo5qZhZS0
X-Proofpoint-ORIG-GUID: 8UyReHqqjqkXftduwHPkp3yvo5qZhZS0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/12/21 9:01 AM, Jim Mattson wrote:
> On Tue, May 11, 2021 at 7:37 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> Add the following per-VCPU statistic to KVM debugfs to show if a given
>> VCPU is running a nested guest:
>>
>>          nested_guest_running
>>
>> Also add this as a per-VM statistic to KVM debugfs to show the total number
>> of VCPUs running a nested guest in a given VM.
>>
>> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
> This is fine, but I don't really see its usefulness. OTOH, one

Two potential uses:

     1. If Live Migration of L2 guests is broken/buggy, this can be used 
to determine a safer time to trigger Live Migration of L1 guests.

     2. This can be used to create a time-graph of the load of L1 and L2 
in a given VM as well across the host.

> statistic I would really like to see is how many vCPUs have *ever* run
> a nested guest.

'nested_runs' statistic provides this data, though only till VCPUs are 
alive. We can convert 'nested_runs' to be persistent beyond VCPU 
destruction.

But I am curious about the usage you are thinking of with this.


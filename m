Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B455D77D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245352AbiF1CiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 22:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245514AbiF1ChL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 22:37:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBAD255A9;
        Mon, 27 Jun 2022 19:35:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gabwtJ7nYeCYdDrpKPdvLtOj+KFeg1j+sbzoBl9fKxPUDliMF9o1HU/ZXuZsWC8A7JhU6+aUNlGuexa/tSZyd2DJ9O6b/R3PV++GQeg59TEbTx5Bm/v4TXOO8WNtgV8mjFhemzxCF+Jn4r8sU10J7Gf/1Fgbj87nC1L/UoDKN3gw7yzoIgoVjo4jr7sedYwN3xc1llsMlDBd/hhtXuJd20OwqorduPb2fFwaqsQWEs/8NWxx04vA66V1IxSCW0YDxx6bQ5FD5/bU+6Ul8Zjqm+qNxf2P65RVBXtJrCajDO/ncY1ILJE6pko0qNCJ7eC4n3HeuzmjNaZ4X+ppottyTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jc2PIydUauT5FWmw1Kctazjak5dhvcz9ofIQG2EgL2Y=;
 b=jPinXUduS1SmI602hbi+Kc9gHud4RVC5JJa6uKONu7v3WGtJjNSXpEZS9+AnL2FNuZV+P0qw7i9XqNtFgAQD7GbhIhm2Ra10II5rM7qMYooD77BL5naZcneITfyTqCFowb2c3oPrhl1cjk/g/K1U4vIIgR1nkzwjk3Y6WoiEKGbrKXYt1GEzgqXCWOWDpkQ5bU5Y9o/23uKvExXJwUX7fE7dY3Ef/AMVOfd1FrrKL1zHg0mIKchjrchHU8ypiLK3CrGwcgxT0oK5jb6Bjku/CFwoR8Hmhv9jQ1zc6bz9LDluntY7zbxiJKPczauTNfeMesqEfXj64bTdFE/wS2PwSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jc2PIydUauT5FWmw1Kctazjak5dhvcz9ofIQG2EgL2Y=;
 b=TmP+F4L2Ne7ZO6yfYzcNLaippMlBRqF8FxKEsSwf88bU/CvBQ8EvPo1DxYOmc/UpLeGxFyPDe3q3NAzdVWq+oR75D5q3Ur8qtoNaHriUm5F6whQZKCYW3KQRvsqXaEZzspBXrSVfwwasWMt/nL35LKqYLJlAMjNvpCgzvs7+GPQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CY4PR12MB1703.namprd12.prod.outlook.com (2603:10b6:903:122::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.17; Tue, 28 Jun 2022 02:35:37 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594%9]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:35:37 +0000
Message-ID: <9f3ffe16-2516-d4ec-528e-6347ef884ad5@amd.com>
Date:   Tue, 28 Jun 2022 09:35:28 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 15/17] KVM: SVM: Use target APIC ID to complete x2AVIC
 IRQs when possible
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, joro@8bytes.org, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
 <20220519102709.24125-16-suravee.suthikulpanit@amd.com>
 <b8610296-6fb7-e110-900f-4616e1e39bb4@redhat.com>
 <d761ef283bc91002322f3cd66c124d329c25f04f.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <d761ef283bc91002322f3cd66c124d329c25f04f.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0108.apcprd02.prod.outlook.com
 (2603:1096:4:92::24) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e83b3a7-a1db-4115-3ebe-08da58aee259
X-MS-TrafficTypeDiagnostic: CY4PR12MB1703:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fbvMRqfPs7sxuoGeltJBcQxi4loM80XEuI9u1yYy6YNIV5Ma57eBE5qfwr+J2aQcEKePS6lBF0tdDf+mn+dZqN0BfcluTxugkzBKQ9nZpw+zvWbkwoKl39WK0EPuOzM16nU61UBbRQeATHAar00ez9+rZyDOhsba4QCf3qwDGHrdCj9IP5+X6xG6zFGGy+1y0dyENyxR+EBe+2sQcMXPSm2HZrUT51BMz2Ccv5dyvgiBQbw8GqubqloAUQho+8qXWyN9L5XVlSXtWPZtkqo/wzePxtCZ5IF2QZflsg201/2voPOGvp9g34ahtWz1e4wZnDOwyPcbb8szsR8PG3dOsltBrMThiTbCAeuopMUXaOs6z2W9UK+pk6np46eYj48pbhrb9Ad8lW/IOJ45yvx5zhRpASnpWJCqusbdRA3aYQ9Jvy1pvSuryeEU3aOphFralyuD1YAMU6lxp4OokCyH8Q8BJvidWVhj5dR052xam6u1ACb0B7m3Ex1zbojXHqH8A9vLoT8Ir7V2ygyHpHANMnPycOOxZP4XawpdmpRgaceNqPHMiX+wWRaHIH/wudnrgiNeMCuf+g6+gjX17wWKEKdr0jmV3KieWxtSpSgyKGKvkOlxZcNRMwa/KzVxkNPgdojcRCSt3cVgYVOgn99GyVRNweDZP/0Rg1B38e/GM746LsV7z4gYYiXJ6DUihLJsBxlylf3152uqkuLD4r3NFAQW4jzwNeEnkmfFwjIlTDe/A2apeo8STCeq6jGn20VMuHzuz+6z6N9P476iCSxsTa/HsKKdmrSGXRwUY65LH3X9RxAUe746j28shz99ZA6zzt6dgL8KgQfLoyKV/BTKSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(478600001)(2906002)(86362001)(26005)(41300700001)(5660300002)(53546011)(83380400001)(31696002)(6506007)(6486002)(6512007)(66556008)(4326008)(66946007)(110136005)(6666004)(38100700002)(31686004)(186003)(36756003)(316002)(8936002)(8676002)(66476007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UndzQVJZOEZ1NDFiM0Mxai9ackxleHZhWWNYNkphU1VDUE5idUsxUUdFeVBm?=
 =?utf-8?B?UnRUVlpnREpXbGRFYnVVWE1uTldLQ25yQmhBangxdlQzWm5nTEMycm00emsr?=
 =?utf-8?B?MWxzQURIMlZoSjZydERFVDhESXNsNlM4OERPRFowZ0FqSStSSDNnSC9BaTBm?=
 =?utf-8?B?ZUpCeHNmTG9sUXJaZEZFQmkvNEYwa0NobkhtcmovQkFiZFhzaTMwSG5SZUpr?=
 =?utf-8?B?SkRqR2RiVWk3NGJOU3N6cXJ2dFVHOElTUDdUaFhHcG1KVUtWWU1mWjdCMDdX?=
 =?utf-8?B?YlBMN3p0V0U1ejcrTEp5OEZwMWl2Um1LV1lVZDZIbHM1NEt0SXYvN3RzdnZj?=
 =?utf-8?B?UHBKK2JQNnIybW1LNThtRFpVUmRyOHhPYUlmL0VKOHJOMTQyZGtSVWR2TElL?=
 =?utf-8?B?aHl1U2hFb2RnTGVIZ0xsSjdTVEtkaEZxTDZqNFhXc3FZTG5XNCtWSDBGTGtX?=
 =?utf-8?B?RlBLL2JhR3Z6N2ZscWZwZ2tXeEtrajNJTGhLQ2d4VDlIWk54Ulk1NzVpWVFE?=
 =?utf-8?B?eEFRUTNQVmtBWXhIOFJUZDRDYTlXdXAvWndRQWdBeThLN3RnRkZKUEV0YW0w?=
 =?utf-8?B?aDJEbHplV01rWFl5SUUrKzMyMS9DajAxMUZyaVdKMkkrZDBCZlFZbjBCOC8r?=
 =?utf-8?B?VlFVMzk3Nk1UN0VGVGltWHhTdEl3YWQzZ1M2ZHMwRkVETXYzSEx1OGZIdXlG?=
 =?utf-8?B?aGhWRW8zK1A2N0VDMzlCYjZJeUlnOUxWaS9iUkkvdVg1K1psckRoT29lYkpy?=
 =?utf-8?B?SHhYTERIMTcwcXpHeEhuSTFqbnZ1dFJiVVJrS2NZZitGWGVuNzREZCtpOW5S?=
 =?utf-8?B?bTJyOXdrbHV1c0ZVZ0c1RUpGRFc4SGk1cCt3QWRoYndkK1BqQ1lJamlqWTZ5?=
 =?utf-8?B?Y2pUTjlFYlJGZk53Um0zMUZJUW8yVzR5U0xCSFdzSkFtOWxvL0J5MnhQd1FF?=
 =?utf-8?B?TVJ2L21NcTh1R1B2cjkzbnNmNFcxVjZ3OHhrS1BKbFJleHp0S0RRRjM3OGwy?=
 =?utf-8?B?WXQ3Uktua1o0ckdXQXpZaWhiMnBMTXMzQ3FrYlBJOERKUFFJT1o1emNGbTdS?=
 =?utf-8?B?bzdmdjU1SzE2TFR2dkp1bE84Rlg3eVlsVi9ObjU5NFpjbVZGNmd3UHRaTFhj?=
 =?utf-8?B?V2VBUWpZWmhxc3pFQjVuTDZBVjM3Tkd5ZXJSZTY4dlErMHo0L0J3aUhva01r?=
 =?utf-8?B?WEwrcURkanBwT1diTVNQZFczK1dlQ2FTbk55b2NZSzY2M2hrSWtxUTRIMlJm?=
 =?utf-8?B?OHNCTjFJaDNWNGJoYVpjbitEeU9Gc0NzSVp1U0t3dHpnbTVuMWlSVUxjZ20v?=
 =?utf-8?B?N2FBdHRDM2g1VVpTRXEydkZneEFlQ1dMbm5BMXZzYUpEUDBwRW9KYk9CcDVa?=
 =?utf-8?B?Qkd3b0FUQVkzUlRDUnRISlFJOUhHZFZQK01PR3RrdDc5akk3UGdmSzBEQUFK?=
 =?utf-8?B?WlB5R2NaUXVzd3hGU2xiYzBIRzRhSUhLakVKUFhnWTZpR3BVaTlqeGh5dU1R?=
 =?utf-8?B?MURiRU9GeGU3UUhsRWFoK1hEaWtBMEl0QTY0ZjZEcGRiYzFZTHNDbHV0cGxJ?=
 =?utf-8?B?R0dRSG1LbEJMZ1NTRkd6ZFIzYzJuSi9XSVJYSmVhUzd2RlhMak4vYWpoY1BJ?=
 =?utf-8?B?dXZjWStoanFNZXJGOFNkcVZ1NFU3V05nd1UvSFpVTmlsWG9RQ2lTSWl4ZlRP?=
 =?utf-8?B?aURlekpuUERSK2xTRVRlbFYzNWE0YmRlQzVOM2VycjdJcGhpSlM5NFBoUEJL?=
 =?utf-8?B?ajNBTVF0Ylp6V2FqNm0xeVJ4RHhKeXJKUWFzSUNVNmpVdUg5MDN3bTBsT2lu?=
 =?utf-8?B?dUNSTndQMVZpZFd1WEpUSnJTeG1MM3liak1PSStlVWNwSE9aRE5rWkRxcHN2?=
 =?utf-8?B?SDRwaXdvNTZDbjR1eFdGbCtzdEdXakFmUlFQNHNrLzR6UFNJV3dhNnZqUUlq?=
 =?utf-8?B?YS9jUHRoOUFGT2xLQm90QUo5S3lnZVYwcUNkSTEwRDQ2MjljU3pTbU9IK2hD?=
 =?utf-8?B?cDZYMXRvQ1k3SVU1eUdIa1JTamlvT21lRU8wK2NkQjRvK2ZFSU5KSk80NUFT?=
 =?utf-8?B?Ty9MeGR6TjBNMXJRNXdGUFRodnBybzRVbUs0cmUrMytaR3p3MlJPcVR3S0dF?=
 =?utf-8?Q?qPuR+pzRf2Se9g9u1de3YYSfD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e83b3a7-a1db-4115-3ebe-08da58aee259
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:35:37.4680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8l5Qspjcp4nITbR4v9VTNnIQ8dNAz5HeJwLZlR38myEIPcyuKWT+k3Dsd/gU8iDFT9C/bAYUstZ10MwcRrjdRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1703
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/2022 5:55 AM, Maxim Levitsky wrote:
> On Fri, 2022-06-24 at 18:41 +0200, Paolo Bonzini wrote:
>> On 5/19/22 12:27, Suravee Suthikulpanit wrote:
>>> +			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
>>> +			 * or more than 1 bits, we cannot match just one vcpu to kick for
>>> +			 * fast path.
>>> +			 */
>>> +			if (!first || (first != last))
>>> +				return -EINVAL;
>>> +
>>> +			apic = first - 1;
>>> +			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
>>> +				return -EINVAL;
>>
>> Neither of these is possible: first == 0 has been cheked above, and
>> ffs(icrh & 0xffff) cannot exceed 15.  Likewise, cluster is actually
>> limited to 16 bits, not 20.
>>
>> Plus, C is not Pascal so no parentheses. :)
>>
>> Putting everything together, it can be simplified to this:
>>
>> +                       int cluster = (icrh & 0xffff0000) >> 16;
>> +                       int apic = ffs(icrh & 0xffff) - 1;
>> +
>> +                       /*
>> +                        * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
>> +                        * contains anything but a single bit, we cannot use the
>> +                        * fast path, because it is limited to a single vCPU.
>> +                        */
>> +                       if (apic < 0 || icrh != (1 << apic))
>> +                               return -EINVAL;
>> +
>> +                       l1_physical_id = (cluster << 4) + apic;
>>
>>
>>> +			apic_id = (cluster << 4) + apic;
> 
> Hi Paolo and Suravee Suthikulpanit!
> 
> Note that this patch is not needed anymore, I fixed the avic_kick_target_vcpus_fast function,
> and added the support for x2apic because it was very easy to do
> (I already needed to parse logical id for flat and cluser modes)
> 
> Best regards,
> 	Maxim Levitsky
> 

Understood. I was about to send v7 to remove this patch from the series, but too late. I'll test the current queue branch and provide update.

Best Regards,
Suravee

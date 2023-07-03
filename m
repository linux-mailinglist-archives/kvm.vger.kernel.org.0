Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7D37453B7
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 04:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjGCCCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 22:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjGCCCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 22:02:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B7019A;
        Sun,  2 Jul 2023 19:02:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqNK6ZodHQYa0GYzKlVdv64gJQFsb3ZHEcYVSju8+MhA2IqPX9R7R8QOWZvzrIn90PiY0ulCbgrZUaysBniRQR5SFP4BV3cCHiC8fUjm4cDmtvfFuNX64Zl4ryvcvhu+LeD9kAo7h/0xemU6hNmcGneMZJJ8EiVqsIkNKunZ32YepWQXzvfWPUoqhEBi43YYKXrRTmRema8UJ5Gr7M4OHHeaghhCDY6XoNKXoXT72spjYc+aLxvQObKvkYJyH1hK5QGwPGub2lE5YbEcNAUa6xMletfP+db8Edb5weo4UF7gJ1R30xb78fXDXepXE5IVxtQUGVgD9HoWUVJthrA7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RL0laYCL7h3qDChvddRAWykYJBjNnV2G7QLDqlVnKDQ=;
 b=AELkgeUk1dSZplyflE7yG/796dMutdnDmwtRGE1HAA2xnPujidD5xrNq8hWdVU7y1ZS0KUtzAWXd2NuQ8eyD7a6jEAv3Unqb5SIC7FuyfXs3tLzM9Yno+yavYTSAbRaYBWhmTVobzHHFydTx1IK3Di2J7LBgmo4BqUbjy6JVJ83KZG8UbbVJX7JURlaT7njkVxQgQ0F+Xj7n+NpbDbKRxAusvdSh9XNAH4ZsJcRm/3HPdkEU95rQ+e1yE9KwenuR4V8XFxDeUMGwrGCTZ3Old+PVNuWOWIGETcmW8C1a0vtJOc1w/Zf7IDrhLj99hEh0e/mkpEXr+VMDCZtIDTIBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL0laYCL7h3qDChvddRAWykYJBjNnV2G7QLDqlVnKDQ=;
 b=EFFJIVpFxY7U1/rWj6BnYIw1WL2uLsA8ftoE3gH7MexJE5pmvBQtoT4PQflUWmG/szkpFNt/iUsYJAp/uCtuirTZxYbfex20Ai485/0H3kdlVw5lvz1WHSjyi1OypNxnDV8a2PmMv1X6k0+TEI3IvnCtUn+2D/FVXhvhEm4ytUs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 MW6PR12MB8836.namprd12.prod.outlook.com (2603:10b6:303:241::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 02:01:59 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef%3]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 02:01:59 +0000
Message-ID: <d3e1e4c4-9b3e-ef43-6779-c021c17c9b4c@amd.com>
Date:   Mon, 3 Jul 2023 12:01:49 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel 5/9] KVM: SVM/SEV/SEV-ES: Rework intercepts
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
 <20230615063757.3039121-6-aik@amd.com> <ZJ9N3GMNuKJXc5wQ@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZJ9N3GMNuKJXc5wQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0008.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::13) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|MW6PR12MB8836:EE_
X-MS-Office365-Filtering-Correlation-Id: 60615986-8fed-488e-7edf-08db7b697c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8yGizKfU+1SaExkU8Dfy9w34iNRika+SPP0tshKkPC2NdzQdyttV9qyNsngN43zrZNs2gMQmhBJqVwSXHXKelNUJsWmO2k3bcpdQXj6QfZdyHhqUtKsffU/63IhipaOfi+TIdLatREV8NmFm7DK/d4sVSH9PkWK3dFbQIWxjngk+YGnJd05yedtNG5vZW5H9ke14Zd9Io0W5nQSpQdfAdhXdqZnu2l0ZdfPEWS1gb8flNkSk787kPPOfJzh5W6K/vfO9M+BA7SiAW7KwNNfT4UqZrAvohfkuOZ1zTOcXdG+XieqCz0EUSzDxs4IyXdvr7aS4QTEXSBkfX2+AVYxerjQIiCn60EaHeZbauXdrVLgZqPltl1m5izechXO2zvqnsfRiusmuHgE1Uqx54pJ/NwVOjY96gACWgxTIWdYCmNAtIgg1nT5kYSd68XadlI5jlYZrimxMyWqBZu8wqFKNhmRE2e9+XidUw3/lW+Gfwd41HpP9Sb/cuhR1srs6FMTJtIZVv8MyIWA2gV/BjWbtjvRbygX2Yng9r6BM2qZtoSV/yJ5gmc9DUqYC/i/TZeWQkv/cG9d6In5xhUhHXEWBHVRZkIdhdbF4f29paxsbtyUGkHBxRX4TRIOnf1nWpDR/Xul9svLxu9kJlWw/u6k3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(4326008)(316002)(31686004)(66556008)(186003)(66476007)(6916009)(66946007)(31696002)(53546011)(26005)(6506007)(6512007)(83380400001)(2616005)(2906002)(6486002)(38100700002)(6666004)(5660300002)(478600001)(8676002)(54906003)(8936002)(41300700001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkpWeWVFL3NmeURTTjVaUGpUUGtZNEV2d29RQnFHWU8vTXFTZDM4M0M0YnRi?=
 =?utf-8?B?YlZwSmo0QS9KRmI4ZFA2MmJRMEpwRGNXcWlKZzFDZ1ZQZXh2NXAvMzdEUzU0?=
 =?utf-8?B?dE9jUnl5WncvMXJqTTVVazBGbGpPeDlsa0x4dXpxdG1oMEVHVGNIclpHM3BJ?=
 =?utf-8?B?Mi9jTUtTVURpZWJIaE1tcUwrMGcxTEx1ZjcrWWFOR25qUVY3bGI3YzNwNExn?=
 =?utf-8?B?SXh3NUJWVDRKcFM3Z2V2WGIwUjNmTlE2SkY2WE1ITHlRcisxU3ZGUWwrOUZu?=
 =?utf-8?B?cU9ISXh2SG5GSnZuVTlRZ2ZvMm5XZ28wWDRLRVpFWnpZZXNXMWZDRmw4K2ha?=
 =?utf-8?B?SjdmNVlJdlJXS29wZ3hSWDk0ZmEzTzBJSnFjdi9CSHJWMGNabnRLYktTZ25D?=
 =?utf-8?B?U3JxNkZldVZXYlBVUjlwMWx5Ny9QR0xvTFp6S2NVMDZJZ2xacjhSd0dPQkFQ?=
 =?utf-8?B?NnE0T1MvTWNiNkppUldFazdiMnVaN3hmdjBGaitOb0lqb0djTnNFN2trdjhj?=
 =?utf-8?B?NzljRDloa2dJQkl6TThaVFc4amNZMDF6NnBmKzR6eDlad0FzVG5JcE9jcTVv?=
 =?utf-8?B?cnFjTTlVMEhNQUl3ZmVqRHllNFNrSm5GaXhhVy9HSUFld3NXOTl0VHJpSWNL?=
 =?utf-8?B?Q0I0TUtTb3pxVm45bElaUHRkWExoY3hrenJPZG9hWkUvNk9nWnBsYlF6VWFz?=
 =?utf-8?B?K2JLWk84ZGsxYzkwMG1KaEhWM3hmVXZnU0I4cDhPaG5Eanl6RGR3eFVKRU9L?=
 =?utf-8?B?TWdUY2ZNVlpVVnRpNFVaV3E5a3k0NnRYa2lDQlYySDlZRDRiYXJtS24yb1cz?=
 =?utf-8?B?MGdoWW5iekY3VW1LTWwxc3dkMS83YW1KMDQ5dlZuYUhvVHNuTE9xTEQyRkl5?=
 =?utf-8?B?cm10ZHUwTzRmVGFaclJYbGhBWXJvYk82M3h5N1dpVXZaRmFscFlPL2J4dzBI?=
 =?utf-8?B?MXZ6V1ZuT1R1SDhoQk54UytUNmNmaDN4UEJkbVhZMEltY1Mvd3FsT0NSU1Bu?=
 =?utf-8?B?ZCttTnh6dzZPczlpV3hwMy9WMkx4QVg2dFpOMVlaWXpqenpnRlY5aFVlOGty?=
 =?utf-8?B?Mi9RalFETEhpK0piSmdOcmRxcS9XRTJBR2ppemRFd0lOeHZwbmFlOFhxWHJs?=
 =?utf-8?B?b3JiK0NsaVE5eXc4ckpMRFlvbkFWZ3Bzb3duZE9acld6c0h6dHZTVDZLV0Vw?=
 =?utf-8?B?Q3drRDJ6RXR1TUUyeFFJUUNSYXdpbUNuODNEQXdMVU1YenZLSkRWSGx2Y1Va?=
 =?utf-8?B?WlRSRmNZYkpROC9xZ0syQXNKTHM5eGlCNU1FK2JXTU00SGtGN2FGV0NWa3Va?=
 =?utf-8?B?T0NRaGVUaDlReERlUklndVNrUkNkV3VNVWRodUQvSjJDaHhJUDhkVkJpTkpE?=
 =?utf-8?B?VlRLemRKWjNCYVVzckN3NGhRdjM1dkxiRDZ5S2pNdkNReDRhQVdGM2hTdGI1?=
 =?utf-8?B?dElWVDF5UHFIRmsyR3REcTlEbERuQ1BUcVphbWRKTFdlQnRPQ1NJUWo1VjdH?=
 =?utf-8?B?aEpUeGFZOVJKUjZYaTFEK2g0c29LdVV3aFdkT1kwYVBqUnV0SWU0TE8zbE9I?=
 =?utf-8?B?RVlyWkJDblc4UlZkWjB1M3F6UHNIM0x1SkxtTDAwVjZkalRtcys5MDhHQTRn?=
 =?utf-8?B?ZVRXeUhCMWN2dElibmNXbVRYaGEvV05vc3RCd1IxUk8rYVh1cU51SXYvUVh0?=
 =?utf-8?B?bng4b1hOM1FYbnRNRzNXTnhNeGF2SHlldXNybDNZYXFuTWk1KysyM1VoRXpU?=
 =?utf-8?B?TTBWVVk1V3hhN05pSXJUUjNwSFdvS1BGVWtHOStnSFhTVEFFcFkvVUdvRVVE?=
 =?utf-8?B?Y1M4eXk4V1dIenh0SmdSYUxJdkFBRkNFMmZrK1orQXhYVG9acHo0WHpGTjFL?=
 =?utf-8?B?eGtZdkZ3U3ZHRE9TMCtrMlBVcHlORHNYejA1RzFxNW9MdE4vQUFJVGNUSmhP?=
 =?utf-8?B?UURncmQ0TWpUVmtaNHNyL0JYQUczcTV4VWYrTFhNN2NIUjJyZ2haMndzbkJQ?=
 =?utf-8?B?alhDNXVKdzBjYWYxcUdILzlDSjN4cG9wclpHZ1ZVUllIanBlVWZIcENxRkxs?=
 =?utf-8?B?cGZpVFRPeGoySDlkUTg0b0R1eDdUeStEeGJPT29sMjltSVVQc2J6TC90K0gx?=
 =?utf-8?Q?pQcQYkhAqvWHnGVD3X5Ul+7Id?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60615986-8fed-488e-7edf-08db7b697c0e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2023 02:01:58.9251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PLIIo07sxp/6wvP7I0ojaK5r4N/EeeZW9q/vuo6G1DiSs3WC04Gboo4qvOZuHUYN7ES3WyHVV2NbTtBK/HFLvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8836
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/7/23 07:49, Sean Christopherson wrote:
> On Thu, Jun 15, 2023, Alexey Kardashevskiy wrote:
>> @@ -2976,6 +2977,16 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>>   	svm_set_intercept(svm, TRAP_CR4_WRITE);
>>   	svm_set_intercept(svm, TRAP_CR8_WRITE);
>>   
>> +	/*
>> +	 * DR7 access must remain intercepted for an SEV-ES guest to disallow
>> +	 * the guest kernel set up a #DB on memory that's needed to vector a #DB
>> +	 * as otherwise the CPU gets stuck in an infinite #DB loop.
>> +	 */
> 
> This isn't correct.  Letting the guest configuring breakpoints would be weird
> and nonsensical, but it wouldn't lead to infinite #DBs so long as KVM intercepts
> #DB.

True. OTOH not intercepting #DB and intercepting only DR7 would do the 
same thing.

> KVM intercepts DR7 when DebugSwap isn't enabled because otherwise KVM has no way
> of context switching DR[0-3] for the guest.  At least, I assume that's the case,
> AFAICT the APM never actually says what happens with DR[0-3] when DebugSwap is
> disabled.

This is the SEV-ES code, no DR[0-3] context switching anyway, is not it?

The actual immediate reason for intercepting DR7 is "SEV-ES GHCB" but 
this does not really explain it to me :-/

4.5 Debug Register Support
Currently, hardware debug traps are not supported for an SEV-ES guest. 
The hypervisor must set the intercept for both read and write of the 
debug control register (DR7). With the intercepts in place, the #VC 
handler will be invoked when the guest accesses DR7. For a write to DR7, 
the #VC handler should perform Standard VMGExit processing. The #VC 
handler must not update the actual DR7 register, but rather it should 
cache the DR7 value being written. For a read of DR7, the #VC handler 
should return the cached value of the DR7 register.


-- 
Alexey

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCF830AFC1
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 19:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhBAStd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 13:49:33 -0500
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:38945
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229680AbhBASt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 13:49:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lObkGGM5DqEWxsZCE96LXd+9L6pavEMhE0/eMhaqyOIpTz1OfwMrMPtaxsMLHJelhfoQY0fZfhq6DLBBRvA9vdNAD6Sg88RIUBHIjULTrrobsK1MITXrxoZFEkPsUjTvYIyLtJu4U94Zg+Hc5m17MLothPwilEEygxw209RxIGWZX/EyV7lmigUL9mb49qwJj7Gc1Qiy+BEo/lHdUkG0D30faUMul9ZSnZM87zRdWmd15OzbNoeUC9U1stCnrWyr7y+H3OedlNUnyA8QU5DtrM93YkwKx5XWLnR2MnZ6e0mYi9mf0a6dgg5BSxXtBo4mM9AS16IFsOC4yWP+OjmkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alf/zCiutV3hIIRAd5wjjjpcaBfWRjQcxUoWKjOSxJI=;
 b=b7+cpgOad4IB4nBhmZQdlUy9UZAIRy5o3H4+++CpfR3BXhKLW0BRZnaEbSwWsytgWcl+fwMt9gJeZYdDtWo70I26WhIkBQrkF/m6G9P+DV6JuxrUwyFrXJHrLy6+lgu8Gy/Xgyb5wtSFLIJcmC7Kp4+yRGLJ5R++vQU8e7oIbY7ekYuYML+2OlC01njzl6IwpV6GB+m2Y4tSUyYc1oA11Ghnlww28IaoCvHJpulbuMu3vv/Qb1yCXGmCnsTO82nIorr998gBLFj/hy9GRpKViGENuH5R2BICyVOPDnT3sbyh4corfWUX7DO7+qjTw2ZGFt3TB8C1P4AdzHN5CH3veQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alf/zCiutV3hIIRAd5wjjjpcaBfWRjQcxUoWKjOSxJI=;
 b=nUsCtIP87mhqUNDSHHu1zooLq8uoKXmMctzeXdNLpflQpboEnQz79iO8SAedGWr3yhGOF0jk3AU3dpRr8zRLKHzerkVB4/agYFae1VYqOeelVMUjlxASoycijRd4SVh80KL6LIlJ5I9hzGY3X+BghB3mTv6HLpF6hzIPulk6LI8=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1354.namprd12.prod.outlook.com (2603:10b6:3:7a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Mon, 1 Feb 2021 18:48:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b8aa:f23e:fcad:23ee]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b8aa:f23e:fcad:23ee%8]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 18:48:31 +0000
Subject: Re: [PATCH v6 3/6] sev/i386: Allow AP booting under SEV-ES
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <22db2bfb4d6551aed661a9ae95b4fdbef613ca21.1611682609.git.thomas.lendacky@amd.com>
 <20210129174416.GC231819@dt>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <08a46e00-940c-eec3-bc7e-a5d21d8f0609@amd.com>
Date:   Mon, 1 Feb 2021 12:48:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210129174416.GC231819@dt>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:806:120::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0055.namprd04.prod.outlook.com (2603:10b6:806:120::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Mon, 1 Feb 2021 18:48:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b44709f2-3a4a-4a45-14f5-08d8c6e1f88e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB13542E0CA6D5211DF4572277ECB69@DM5PR12MB1354.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ugVjVLNUlmlfthcU+gBP/1VS4PN1DZnr18A8ok+0jaEipjM+P8AOjzF1CzBz12EBhW8AhhrSpPsTU0Sr9DkSEz6e0WkxNfw8FI67pJOA5ZjmqA82sm9Q2XlqpNfm+YFaZteL+P9xXYHan3DOElB4sITcnhWLzyuAbT6MhydM3LMeKl8eBUO3Y5AhgJlI0yXXCpg+/T+GRseLhziP1Ypy5FjOsULNn4TzcP64gNPN2sMS6D0bqUy9bvZPm/NdOCUBXvhrn0HFgGQaOlLA0uvlYU5GskhVLrE4y76RpSGwEKORpbH25hIkL9jRZKHZrzC2ckWyBo7xtseKBrx4YJmHgxpcOtcovxdbAsObdywDinflo3mkUpXWxX7Mxo2kmuY+bX2cC9XwFR4kaQPeS6sjYWP7FuciSyGCuYRTBLdEXWkfiPPFV7UZM/pSVnzAK7jMZK5LCYzV52v8tCvC3BQkGcgjZYnvMNykO3/YCxcFkIZQCPy7zxwfanVazZHZ4EPlwNcWuhwBLz2EyVcmmWtF2CLRHhD2T7Z87UTgEKfo4fpucIWiO93UKBq/EayZGr09kYvBX1TL3hEoxBpNSQnh39Res9im0GrpIUWkmJSmuVo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(52116002)(7416002)(8676002)(6512007)(54906003)(6486002)(6916009)(66476007)(83380400001)(66556008)(66946007)(5660300002)(8936002)(2616005)(186003)(31686004)(2906002)(498600001)(16526019)(4326008)(36756003)(956004)(31696002)(86362001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bmpYWkhwQnd4bXVuNjlpYkwrSmFmbXYxZ3dOSHhrdnZxWitPYlNWeUNIb2Nm?=
 =?utf-8?B?eDBXcWIrMkpPVUhiYjZ5T1VjTUpxSEdJMEM2aHBveW92YklnbjQ0aTB2R1Jv?=
 =?utf-8?B?NXdhMzJNOVBXVGRYYVNNUldwaWNaVlRubVlwUHQrajhYaGNsT1liRjV0WlVq?=
 =?utf-8?B?cjRLS3hGaUZXeUc0enVQcy8vdnVmV1hoNDZpcHVuUXRtWURjbUJLYmY2cmdB?=
 =?utf-8?B?MkxSMWlzRmZTVWJUelBqT3ZodVl5WG4zbGhoRWhkTWw2VUFOZ0w1S2h6Ti9n?=
 =?utf-8?B?TS95c1NCSzg3a283SHh3SEx5Rk5zU1FMYlFhM2dYS2FobkhTdmVTRWRYbmVM?=
 =?utf-8?B?Y3NIbEdQY1hpejIxYjZvZkppeXlVWi9XaXZJbGFDdUcrVTVpSG02Z1IyeDJ1?=
 =?utf-8?B?Y0ZVMlVobXNXQ2VaUlJKSFUvMFp5dS9KeXVKcDZEQ3VMSWlUbEk2MkdkOTRS?=
 =?utf-8?B?MnFNUlJ0UzlSOHc3VVBkTExaTDN0WG5tak93TS80Qmh6NWNtamJZeUplYkVK?=
 =?utf-8?B?L3pyNlRSeTNJdU1JWmNvSHYwL0lLR2h2M0hlcVRtRThKTkVrME5Xd2gxaVhu?=
 =?utf-8?B?d2V1SWlOMUZ0eDdGZCsvb2hLd21EeWVVL3Z6V2dPeG93QmNVS3UxVnhkOEE0?=
 =?utf-8?B?d3p3VjRoQ0F2UFpsT3hwc2VSemNWWnpQa1crQWswWmdYc2tsU1llRk15Q3Vm?=
 =?utf-8?B?bnBjV2ZNQktLQVlGanJkdk44YTFmU2ZkeTAvUytqQUxCYUtJQ1FjZDU4bUdx?=
 =?utf-8?B?bUxVV0hZVzdxZGc1ZndvM0Q2QTBsVXZnMXlwQXFGTTJLT08xSExVTTFoVVN1?=
 =?utf-8?B?OEhTNi9HWUIxeVFwb1V0QkN2cjlUYkV3NjN6SE5rU21XbUowZGZZQm1VOUJ2?=
 =?utf-8?B?aVF6N01IY3hyZUdSVzdvOWZ4VVZGbytKYmxRNkVpN0QrK1l5YnV1dUplM2JF?=
 =?utf-8?B?YUVSZzIvRHYvS2psRXVFQyt1R1gvVzNZT0l3MDJYQmQvY2xxaHAvcFZTb2No?=
 =?utf-8?B?T2I2M1l6cFdsT2g4SjFrenRoZmZHMEV0ZEZYbkN1eTg2dGtuZXVPbk9OSVRa?=
 =?utf-8?B?V2hLWk5pOE94NncyN09WY0lqM2xjaXU5c2wyeWQ3WWFsblpKNTRtTEVGdnUz?=
 =?utf-8?B?MGR3MzZDN1dIaDZ0eXpVK3IzL0FQNlY4UnZpMXNVbUZwVHFXc21oSXRvUnF3?=
 =?utf-8?B?N0dLNmdYWTk2MUtxR2ZQZFEyU2hlZllJbEM2N0h3UjQ2YVhQc2JaYVZsL0Vu?=
 =?utf-8?B?MVZoYjd6Skw4cFhOd3VTT3FRVWVIOHBiK2VtMk41aDZZbzEyNUZYaEw3a2Fv?=
 =?utf-8?B?K2h0T0RsR1lXSUJHaFZiSmF3SERQRVZsSUV2bTJVRTlFcTIvN05xV2JFVzBF?=
 =?utf-8?B?cWNsQ3c5R1hJNTZVckIzdFVpZnJIWWV5MlJ6bHI1YXBPOWtETHdwODA1NUYx?=
 =?utf-8?Q?mQVMFhim?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44709f2-3a4a-4a45-14f5-08d8c6e1f88e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 18:48:31.4886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvkPzCFD9laIUMCG97Lr61Ds40v9s6QjUDi6BAtNrcksSs3DV912Qu1kmQHOG6UcluGKo/cVn/sOYjVRzKDtZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1354
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/21 11:44 AM, Venu Busireddy wrote:
> On 2021-01-26 11:36:46 -0600, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> When SEV-ES is enabled, it is not possible modify the guests register
>> state after it has been initially created, encrypted and measured.
>>
>> Normally, an INIT-SIPI-SIPI request is used to boot the AP. However, the
>> hypervisor cannot emulate this because it cannot update the AP register
>> state. For the very first boot by an AP, the reset vector CS segment
>> value and the EIP value must be programmed before the register has been
>> encrypted and measured. Search the guest firmware for the guest for a
>> specific GUID that tells Qemu the value of the reset vector to use.
>>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
>> Cc: Richard Henderson <richard.henderson@linaro.org>
>> Cc: Eduardo Habkost <ehabkost@redhat.com>
>> Cc: Marcelo Tosatti <mtosatti@redhat.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
...
>> +
>> +    /*
>> +     * SEV info block not found in the Firmware GUID Table (or there isn't
>> +     * a Firmware GUID Table), fall back to the original implementation.
>> +     */
>> +    data = flash_ptr + flash_size - 0x20;
> 
> Even if the SEV_INFO_BLOCK_GUID is always located at 32 bytes from the end
> of the flash, isn't it better to define a constant with a value of 0x20?

A follow-on patch that updates both this and the table parser code from 
James would probably be best.

Thanks,
Tom

> 
>> +

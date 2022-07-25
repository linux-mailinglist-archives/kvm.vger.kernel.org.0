Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246C357FF37
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 14:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiGYMqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 08:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbiGYMqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 08:46:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD70313F99;
        Mon, 25 Jul 2022 05:46:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEdCqwGoCrFk0XpKO586wAuHSKTAUnQEpzrNKyp/YTk6P9k6qaR/sxsSWW4EfCF/1DDfS75zFGIDx1Z5VooJDsfEa0b3B23gBJdDQMz9AywL/jlXUJF+rrvHizJYtHKKP8Qf3Yo42yy+cUSnORVJsK1lidPu0LLAGaoaJW0pqOc/qUheCXWVMKzf0YNmFn1qSeqK9Al10fo6azy/qEoRtUXBGnyqr3VURIPWY/5io93M6c9T8k6Htr8azB8rJ8gg42AMPWdvICdiAR9UqY5i3mbTXMeenSG4irpoUa2D6vs0IP9+d8CQBZtMcPIHWjZ2d/3PJ4rURBRuRzQJaWIYEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvJ6LA4o2QrLgoMMRemMcTM7I2cExkFxDEzpMzwI+0E=;
 b=aDuFaJySrhqPeWEcKGrhzp2W+Ff0mxogBZGEIZr9HBq8cHlgjGOpUcnjqMU+a2OzkRW5X0a4DXNIf7xIBjrPIGjzqGpeCzAJlVPLLtiqIdRFhRE3pYW+ngrqb1lM1DSFwgA/rAGt/U2bmzjH9VBT45N3kF/jMIH96+SGry2o2aIQRSlh5f3zHPdW3KZdJEiHhPty22w0lK/wdnPeBsuWCgOFJCb5NclautcFN4iS+bwyzJNFzPW6N/yq0hgYiM2Be88p5BjwYHMQ/vtuB0JYEMKNYrbT6Tt7xVK+Kwwbo4C0iY83p9kJICy7vkxv0odCRV0nILHP2JnJtaCHT8dIXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvJ6LA4o2QrLgoMMRemMcTM7I2cExkFxDEzpMzwI+0E=;
 b=kSx5MVBlITCry+1T4MJK8KfCzme3NwgDwbf7XL7tehsiQgAAz06Dz7D1HfiWG8RIHz4hht7B2UI4b2SVhNIaLy5zbctYnfiPz0uG62Fd8wn0/Y4h6TOlTpY4+T6l/f8vV/YwbB3FZjr6AnxPzpzqyfG5xyZ78S2pU9tJqByx+BQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MWHPR1201MB2494.namprd12.prod.outlook.com (2603:10b6:300:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 12:46:20 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::d4af:b726:bc18:e60c]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::d4af:b726:bc18:e60c%7]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 12:46:20 +0000
Message-ID: <dd494ece-06c7-0330-7ab8-e0c736532d50@amd.com>
Date:   Mon, 25 Jul 2022 19:46:12 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: Do not virtualize MSR accesses for APIC LVTT
 register
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, jon.grimm@amd.com
References: <20220725033428.3699-1-suravee.suthikulpanit@amd.com>
 <4d03f8b0-723c-7ac5-5078-95330e888e60@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <4d03f8b0-723c-7ac5-5078-95330e888e60@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:194::21) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbcc3c8d-71fe-4821-5b56-08da6e3bac2a
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2494:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vsoVV/dmFsglYeSm1dsCGIrhGNyZ8we3rVWsJXKSz9ab86f+Yemxs0KYPPgW1ts3COT2/W/N306beTFegWO/Rw2YHQzaUAzY/ZKfJHSGXLJrnD+X7Pj5sWxRPKeYsH/erR7sO06xAM/U0h4DgoiLZTdxQPXnifD5wYd5vRjZYCN3XB+2xDY7jTOC8CUPnFCZJhPjLy/kT6OrRAj3T/ROygtZDddKZl+kyNUwyF29g4WlxbO1JHmM5KB5guZuRxYiDRNOln4vuAnMHPIk3UQukXZDvvAgVms51vvTPoX1JFAYXkiTmdh/HxyTIVWD/xLYt8pxL3twEvvlieqYG/hEQmqbc3nK53dkZmQTOBXWNCIlNGO4znuaNSYDXlg7lfcWmc1O2hgFNEGkoJYBxvN15jamJ9M02/HvS5peD500WTmT9n123pStAebb/G3I3dR8/fVbRB1JPGmbzIt1dtfswzfLIw3frPyEwIYlzPn44XAFbF+TXn6FRNo/c0nYVKjkKqdk3vJ9PeismuaMPqoUm4nyVX2lhh4QkjFJiwKRtAVg/FYFv2CJ42zyO7cLqlGJOdOVRJ1ykSbM54eSX1hLK+Gx6+QLbBRVEf6UDtcQGx4wM+oRvdQ/q5KPkNdrkQO3pKLVJfuHKzVX0AJLcEJJx2IjSFfkJNPirbkdftL+hawUyL5bsWteT7P96J8hnhymHIWTJ/fVEilsoDUEr/oUq1aOr/Q7jeL0msEtGZl84soLosC86Vls/nSKwB0rPjKqv1FpshqgeXf+CxwCagU4OCZFM/1HKempcuaU2ZpJQX8gcZ0DGOxsuJrnWWaO3ga2f16UELCxnf9gUmRi3OfG9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(8936002)(66556008)(66946007)(66476007)(36756003)(316002)(5660300002)(4744005)(44832011)(6506007)(31686004)(478600001)(41300700001)(53546011)(2616005)(6512007)(6486002)(6666004)(86362001)(31696002)(186003)(83380400001)(4326008)(2906002)(8676002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEQwQ3VNVjN5SGxSdXVVc21ha2hkRGVxNFdjUUdqWndZZU9kR3FFN2IxMG9l?=
 =?utf-8?B?dnZPbUhHTHA5aURlVkJTYTUrZEtVZGdOWFF3b1R3VC9XV0NrT1VVMkx1S0c2?=
 =?utf-8?B?NzQvRkdUYUtidDRLb0tEbnFJeUVub00yWklXRzhEbmNlTDdmNldxZGpycWUw?=
 =?utf-8?B?cXpJdXpQL0NyckgwUXZWRmxyUnQ0K2FFZFR2WU5EdjViRUcwYjF4dStTK1lT?=
 =?utf-8?B?YzhXa1FRdkxZU2NacWFyeDdZR1FZRE9IdHlIdk1xaW42SGhtSFlaQ0oxZVBU?=
 =?utf-8?B?eUdBd3VVKzdpNzBBTVVaTkFTSmpDcUQ4Uk84aEI0QkxRS2p1eXE3czdGSWk3?=
 =?utf-8?B?c2h3eVVKcC9nejdZZHNJTjBYZzNJZlBkL2RLZEwzK1VseC9Qa1VPN2xvQkRH?=
 =?utf-8?B?YXUrZVp3NlZSL1ZRcURQbUN4NWY4TFhTTWdBQW1KS1dzdDFnTUt1ZURMQjBQ?=
 =?utf-8?B?MnV2UCtQY25SK0FRSzhDQk44Z2dyKzA4TGZBck5BNUdtS0laY0Y2dGpwVERK?=
 =?utf-8?B?QlBqSzE4YTdVOTluamhuSjhMNXRNbWljZ0VtZEJWVm5lKzRqcndzODJBTXJu?=
 =?utf-8?B?NStDcFdFQ1N1djVBZDhmdmVzajZhWTdUZFVqVkJLSDlhL2kyNzVPOXV2akE4?=
 =?utf-8?B?WU9HdmF5UmFzT1hua3FrVU1YQVZERVBBem8xUWp2c0JPWnVXeEZlNitZZVhL?=
 =?utf-8?B?emtRWUhXa0RadFB4WlBrZzlHcWVQT1d2c2FjcmpoMy9hYVFSNC9waDllVXhn?=
 =?utf-8?B?bXhOUHNTdE5ZRHgzbTA5V3g4WnZJZjJNbUN5OU5VNVlDa2JEckdNcFhMMWtq?=
 =?utf-8?B?TzhwYUE5aGdoYzJudjBvbmZPaUtwQU9LUlM3ZjVMM2U4WWZFREtHVXJmMWx5?=
 =?utf-8?B?b0lBVTZRMmEzRmtLTm4wOFZtL1k0RmFiMnpNanhUT05PTlFKYU1nQVNPUm9M?=
 =?utf-8?B?M0x5bDNCMmZtOXh1UkF4YUUvaVE4RElGbnNJTW9UZUZVSDFzUVBUZ3gzbUY0?=
 =?utf-8?B?WDZEL0M5OFBUZkhSOWpEUWZtWWJPOGRMcitFOGRFRE10ZEZvWEgrUGFIV3RC?=
 =?utf-8?B?bnlmdWRESDVOaDBSL0pUQmoveHhTcXlHWDVDWmFMMmFEYkdyS2R0bnNPdkNY?=
 =?utf-8?B?RmlSNjVmT29tM0czdUt3RUxHNkUrT1dCWlFxK3ZvMWFPVDRUeTdsSmcvaHZR?=
 =?utf-8?B?cGNIRWozcVdGbUE1QzhXY0xIQ1lZNFNEc3JkakF1NVR2d2lmWlJmWjFuM2FK?=
 =?utf-8?B?TkdldkE2QklTUmZQWVdYcWMxK3VnZGhzNHAzZHR2eHhBQTVzbTJhV0tHZUt2?=
 =?utf-8?B?SlVKTEdQaWEwc0ltYXFOdDlnQ0V1c3QvQnVwdFhhWk9jTGxoRk9jd2hSQzls?=
 =?utf-8?B?NlNzdld2Z2lnWkZua3RBRk95NXlJNjJFOXl1WVBFekxEL3VMSmNTdXJscWRi?=
 =?utf-8?B?dU95VktBWmVnSnRpUit0ZUk4dmRxRUloWG9nQ2JqbDBFSmh3bzBjMlpvdkll?=
 =?utf-8?B?QjlkaHB4MllMcm9LakxCSm5nUE5rMDY4dkFIdVRlMVRxb1dEM3RjN3g3bjFP?=
 =?utf-8?B?WEJGTHN4RmpMUFFpTjRIcXZWN0NVRjlKYkc0aEFKcDNubDhIOCt6eXNnblY3?=
 =?utf-8?B?a09qajgxNmMrMFROWnE4TEVUakVrTlF0bWEvTDZ5Zzc0aGhDSFhlKzRBUEY0?=
 =?utf-8?B?UTV1V1pKQVFyMjZDUmJZc2s2bHV2bktXNGtqWGRzUG1ENlhydzYwTlMzRTFx?=
 =?utf-8?B?a3BudEErVE9WbEQxQlRLZ25TWlJCUXU3ZGFBNUlISCt1cGNMVWpwb2FKR0lN?=
 =?utf-8?B?cHpucU9YK2xOdCt3cHNBdEdCVGYvT1FGWUNSdTh3N2puZDNEY3IzWnk1ZG90?=
 =?utf-8?B?bk5yMVRHS2U0VjRhRzEwbnBkQTlsVEZFSFhQc1NsYnA4aGNmQTRlQ0hjaFVx?=
 =?utf-8?B?T3BnSDRKTmdlZXk2UUJUYVlRbGhuVGVFSnBJUVM3b3NzVGZNRXZUY1ZLNEdV?=
 =?utf-8?B?QThHaUpKbnlDTDdHR1VxOVdrUHFReXdieTRBK3poYXNwVFJRTGZGQWFlL0d0?=
 =?utf-8?B?clY3enpPRXY4cTRZWXdQK0hGNmlUcHA1ZzVxQkQ0TG9veTFNbkFvaFlIUFpT?=
 =?utf-8?B?RkhhSERjcDV4T0hqdG9pVU94eXViZFBvZ2lFT1MybWg2dTlpdDRFY1AwdmVG?=
 =?utf-8?Q?CvNS99MYxu8JI7yDlqvDPDhOXPIfmqerwktAkg8DtCmG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbcc3c8d-71fe-4821-5b56-08da6e3bac2a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 12:46:20.1772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdQsPhVZX7UckchSL7IhZplIQti2zK15i3GnbyIw7YxHkUu7mO+3oPaLmQI0hF9rDbaA0CLcLyTd9KYiJFFk0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2494
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/25/22 4:46 PM, Paolo Bonzini wrote:
> On 7/25/22 05:34, Suravee Suthikulpanit wrote:
>> AMD does not support APIC TSC-deadline timer mode. AVIC hardware
>> will generate GP fault when guest kernel writes 1 to bits [18]
>> of the APIC LVTT register (offset 0x32) to set the timer mode.
>> (Note: bit 18 is reserved on AMD system).
>>
>> Therefore, always intercept and let KVM emulate the MSR accesses.
>>
>> Fixes: f3d7c8aa6882 ("KVM: SVM: Fix x2APIC MSRs interception")
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
> 
> Does this fix some kvm-unit-tests testcase?

I am not sure if we have kvm-unit-tests testcases for this.
I found this when enabling tsc-deadline option in QEMU causing
the vm to fail to boot.

> Anyway, I queued the patch, thanks!
> 
> Paolo

Thank you,
Suravee

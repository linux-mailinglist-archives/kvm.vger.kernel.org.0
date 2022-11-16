Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B9B62C59E
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 17:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiKPQ6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 11:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKPQ6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 11:58:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87E16441;
        Wed, 16 Nov 2022 08:58:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVMwmyLXIRPo+iz9/khw22B+Ew5B3XC8OMoFghESg1Qkj1iao/s96/J2gvvtIQ0SMQPL1NAWa8kU8h6WNxAK3fQ5V1sGBBnIkRkUPit+dvR4EYuhLAzCi3LWMQ8EyWvsblq/WDMexSfQL9qxkn058INnG+UvWEi9Y/G4dFnlD3cGAT3zFMosRbw6p3L6poRAUxsIsvxbYUkt795v1TyIRbJPt0QTHXTH9UoXWPT4qn4e5+IcEmiZuflLK6zpBMPersxwhMs3XUXqb4JSp6WWY5tCbz5LSAs3v3ck2b/NV08jGH0441BGtOu12ZJw1JTnDI1eNqQXjdwFFlfNf2xCHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvS3yH0IsL0JQjIEYCW8WXjT0TwFT1Ss0wM2Ut8dRaY=;
 b=WJ5UjbsXllvg6ElNvYYEYGb36A/AOBsIgyel5epk5vYZ+9qaWoiVSIhoIq+R3o3yo2yOe2uuaRWDXYZNhYTBH5m3b4hKJD5JuQ56qj5QH8OQSCNClnhxVMT3CWmmUXbDx/C+zrGlNsDrvQD9kQRoGd0TEcrfZc4Uw5lX8IkoCEgtNN7nUxxYbYfltdtaBs3usXQwnFl/ab6hnFsmdOCafF7lLW2HeUA5OB0VgeTRx5F3LjUCnpsNsDlDzN7rfTNT+abg0JcbJwv+ZAfPXHiVRGWlOHNfUSUuZwhVKu6WBPXl8jlELgX4HJGiPCdW26WV/UD7Y+e69uGZlGA9g/H4xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvS3yH0IsL0JQjIEYCW8WXjT0TwFT1Ss0wM2Ut8dRaY=;
 b=pKaqoju7PQceWoGihIO18pencsfsDl0DMUWjjiWbNMCRLWdHAvhaEC2+DYm87tZJTVQwoYQiiwKV24EuZSNnDeUkzOZf5GcjO8rRtGEyqdfkj/OAQP9RvnOjdaadU819pjwx7pfGzWF24OgSUNRO5Win4Q2FE3htFqF9rtryvgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS7PR12MB6191.namprd12.prod.outlook.com (2603:10b6:8:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 16:58:35 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 16:58:35 +0000
Message-ID: <bc070ef7-8168-f1fc-f5ec-aeac204f2ef6@amd.com>
Date:   Wed, 16 Nov 2022 10:58:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH V4] virt: sev: Prevent IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@suse.de>
Cc:     Dionna Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221103152318.88354-1-pgonda@google.com>
 <Y258U+8oF/eo14U+@zn.tnic>
 <CAMkAt6o-jcG7u1=zw4jJp5evrO4sFJR-iG_ApF7LhT+7c55_Wg@mail.gmail.com>
 <Y3TVcJnQ/Ym6dGz2@zn.tnic>
 <CAMkAt6qQmkufbuotzMA4bMJaA4uBFMdk8w7a3X+OH3JaOdFepA@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAMkAt6qQmkufbuotzMA4bMJaA4uBFMdk8w7a3X+OH3JaOdFepA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR07CA0066.namprd07.prod.outlook.com
 (2603:10b6:610:5b::40) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS7PR12MB6191:EE_
X-MS-Office365-Filtering-Correlation-Id: ff5ec1d7-eb8f-46a6-72ad-08dac7f3cce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XTkkR93Kli1Pg6ZM+qPIjAE4M+M89T03MN34hQjTodHv/4oCEOZ42y2Fwe28LxZcYmPCx/bHoAWwqCXNqL1QTcfoVgREGoVktof94ymyimAaJNlcyGq3eIswVW38Fo4j8awQiLbLelvSMDVnBNHrSRuVHkN7JiJp/3DPYsjTfoxzhh4JcqiltbNswBdpbR92da1/vZcY4vdFtZKkG55ahv1VEEVAfucA/1Ll6rnEuw1ZkNwGFpHUl3jKNG7kKyvfYd36Qs0ePagqReQDWailGgU5ZoIhsZxG2XP8+/XNem+4zLrHWRwzVZHVGVViMRO8QKbt0kSXTub/XEK7Efj0kAOnHUm5Gg1FsX9MogyFzRlzMDMPfCMMEvbEsptK5edJfkUdFJS0xwMc4/tXFWTh99uXJnVEJxahqmn8m/FufnAxJgM3R4Fn0qO1ES8j+CXVV8gfV4v4Xt10hQ0DK0gHI0VCIPbhSsggd3QAXI1T3P9Egj/8XK1WwTeUDbm5jNSuKkqfhdsS+x+YLj5IdwSdCbiqZV5t43iiCCW9n2DGRrraykyTWXym6e4mN+PpTcPEDcpxzvz05hUf/XLzRJ0quVodxRQ9HEJdwjh1l9MJMXMLBg20AnucKvYXrjCWdC78t/jIGe3PqXPZ17vOY3PomNY5sgBND/JQJJLLX4efjdQuiU0s+rzR6cA/f3o1h3Zv67e3LTypMQ2cL6GN1+QceRnV61xEDrI0dJnfm3DrFsxXWyZnlgAASXi0Iyrzj6MzeP2ScXrXTUZxK+DjjS9p9glJY+bS3IsFZydqvU9T9Uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(6506007)(53546011)(66556008)(110136005)(2906002)(54906003)(66476007)(6512007)(26005)(186003)(8676002)(66574015)(316002)(8936002)(2616005)(5660300002)(4326008)(478600001)(83380400001)(41300700001)(86362001)(31696002)(66946007)(6486002)(31686004)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZklaS3Zra0h1R0Zwa0dnRDlFMlo3RTZycVNBRDhETFp3bElEVTFTRDhKSzBS?=
 =?utf-8?B?bk11S1pDRFY2bnVpZmFzUkI1VHFNcHNpZHJTNTN3c3VsbVZvbUNCTnlsSUFZ?=
 =?utf-8?B?eUFUMWxmRDRFQjlPUEF3S1cyN1JMd2x6aE5scjNFNDNINUE4d2hNN1U0Smpr?=
 =?utf-8?B?SGs0V1VDOFJOV3oxcGpmUWJnem13alUyTVpLRWEvWVRYVWlSeUNyUXlmcEVG?=
 =?utf-8?B?UkQyZWRiUWFOVVhObnY0WkRCTlJORnpmWmpPY2VreE9ndDBvbXhmdHJReHVS?=
 =?utf-8?B?SEF2ZjBzbGd0b0tkalZob2g1bC9KQmYrSVZRcFN1MzdUeGdLZDQ2TkZ4RTMz?=
 =?utf-8?B?Q2crQnE0eC9QUmtyYWJSRFlrZDA4emhYcDArZTdKWE9nd2VadGRCQW95eTR2?=
 =?utf-8?B?Zk9GTHhtY2xOdG1IdHZCaTFjS0F6YW1oRzNtOStSZDd5anI0T0ZJK1UxazY5?=
 =?utf-8?B?WndGMnBzRGlvL1E5MzdCWlAyS3c2eWVKUitUOHRGeEx4RDB6dFFsS1cwR2xK?=
 =?utf-8?B?bi9WYms1aXZtYWRyNWgwYUIxVmw3ZkV1NXRFWHVhRTlQMVF1ZXhUU2twQUFo?=
 =?utf-8?B?VVpBdDl0R2IwUk5lK0ZQc25FTDJJWU1oVmRGKzN2WVphcHB2NVA1K0cwWWp5?=
 =?utf-8?B?cXdicXk3R3VmbXo5Vm92TEkvWTRmMmF5MWgyNXptbG5pT1lqS0UyVlZ6Sk14?=
 =?utf-8?B?YjdwOWNFQXJSMnFWamlIRTdWVzUwR0g5dkxldXk1aTl2aEk4cDdGZGRaV1Zn?=
 =?utf-8?B?SEZhdUorZC8ySHh2UHpOYUEvdjhxamdIRGVXbnBXRkkwa3VHaHhpUUhCZElK?=
 =?utf-8?B?YlFrVGQzaEVnR1Rqa1d0RHlpNmRKZGZsNkRIZHRyY3RLcEx5WnE5NGg1U3Yr?=
 =?utf-8?B?UysxRzlZbjBXQmo2SjRpOGZTYitReUJIYzVHTENuTDRhTzd2MHQ0VlV1NWRX?=
 =?utf-8?B?ck5FK0xsZ0NhTVJBNDk4NldwM3J2eDNMVzdmc1VzSnFRVlhFZHBQTytPSEV4?=
 =?utf-8?B?QXYwdUIwaU9XVnVjay9aa3hHOVFKZzRIU20ra2ZZOGFJRTZBMjJLNVFqczFl?=
 =?utf-8?B?Q3dyZWUwM3h3U0grbUpTWjVVL2RweXVLU2xZczY4ak1pU1BEV0FKa1VsUktl?=
 =?utf-8?B?ZEhYeDBMcVV0THhOVU9PK3dDcm0yVXRLcVJGNWQwUUJWOVoyZWxYVVRIazZD?=
 =?utf-8?B?VnFxcUJQOEMybGxhZWY3VEZMZVpxMXNialAzdlZjNERYQ2kyY2NDclBvQ3Uz?=
 =?utf-8?B?TGcyZEhFb0NzNGxZQjdVeDI4R0JzZmMrN00wblBCTXdncDg1QlhMenA4MmNE?=
 =?utf-8?B?aHBWM0NLK3hMZm5vWWxFRnpHMFphVS83bVF0UHdSTjh2MnlVd0xEa3k1cjN3?=
 =?utf-8?B?cmZHN3Jkb0w3NTBsZjVyYWtqWm50RnF5S2l3RjBUWHcrYWFyQmR6ZW1DTC9z?=
 =?utf-8?B?eGh3TjRCWWoxaU1wNWZqVS85bnVNcGRBcVh3ZFpTNitSVEJIV3pudW1HcFpY?=
 =?utf-8?B?KzRsV3hrMWZuV3lIUlcyK0ZXZXN2d0lLK1IzNGRHbUdTMU5ETmV5TVpqVjFp?=
 =?utf-8?B?V1c4eEM2VGd6ekJLYng2eVdaTkdlNElHQlJlYkk5NDhWMUpXZmtkWjd6NHll?=
 =?utf-8?B?dlpOa29HNWphejJpd3dXK2wvTExpeUxZYTJhdTFMOEhEL0hINHAremF0THBw?=
 =?utf-8?B?N2cxVzJyUmh5clpha3hxeFJjWGxST1V0V1pia2ZaMFBOY1hxTCtva0JXZzNR?=
 =?utf-8?B?cVYrcUJlZFRKLzVRTnd2dXJJNklDbEliT3VuYmZST21JcGM0T2lua08zU09W?=
 =?utf-8?B?YlMxQmppa25PS1RPUjh0Q2w4b0Q3MnAxVTl0VXhaR0ZRZDB1eGY2NEptcjVk?=
 =?utf-8?B?V1hvbmozeSs4WldlT3lxamJyRmlsWDZ3N2U0WXZDTFRwRFZaN0pTYllDcThn?=
 =?utf-8?B?ZGt6U1NqMjZBSGN3cHJNRE9rWUIwTTVzY2Q0cFJGOXNHSDNua0ZDYk43RjFO?=
 =?utf-8?B?WC9NcXJhVHhVdnc4RFFiWTFoOHF2eXI3Qy9KWDlsTXBkY0pzZS9uWXpOanhq?=
 =?utf-8?B?dE8rU052THZvZGRkdzNlSlhtZnhUaFRlRERnMDM5M3ExRlk0a2dwRHlNcmp1?=
 =?utf-8?Q?hHnrc+lhkTncftkTLO2zjZ0lk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5ec1d7-eb8f-46a6-72ad-08dac7f3cce4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 16:58:35.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3zifmhqgocaysaRNBo4rp56CPnlu1kjrjBZb1xqgoHBc3iDhc6I6lSpznmDiNuNSAv8+8gUcV79qz21ApEwlmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6191
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/22 10:23, Peter Gonda wrote:
> On Wed, Nov 16, 2022 at 5:20 AM Borislav Petkov <bp@suse.de> wrote:
>>
>> On Tue, Nov 15, 2022 at 02:47:31PM -0700, Peter Gonda wrote:
>>>>> +      * certificate data buffer retry the same guest request without the
>>>>> +      * extended data request.
>>>>> +      */
>>>>> +     if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
>>>>> +         err == SNP_GUEST_REQ_INVALID_LEN) {
>>>>> +             const unsigned int certs_npages = snp_dev->input.data_npages;
>>>>> +
>>>>> +             exit_code = SVM_VMGEXIT_GUEST_REQUEST;
>>>>> +             rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
>>>>> +
>>>>> +             err = SNP_GUEST_REQ_INVALID_LEN;
>>>>
>>>> Huh, why are we overwriting err here?
>>>
>>> I have added a comment for the next revision.
>>>
>>> We are overwriting err here so that userspace is alerted that they
>>> supplied a buffer too small.
>>
>> Sure but you're not checking rc either. What if that reissue fails for
>> whatever other reason? -EIO for example...
> 
> If we get any error here we have to wipe the VMPCK here so I thought

More accurate to say that you will wipe the VMPCK, since the value of rc 
is checked a bit further down in the code and the -EIO (or other non-zero) 
will be result in a call to snp_disable_vmpck() and rc being propagated 
back to the user as an ioctl() return code.

Might be worth a comment above that second snp_issue_guest_request() 
explaining that.

> this always override @err was OK.
> 
> I can update this to only override @err if after the secondary
> SVM_VMGEXIT_GUEST_REQUEST rc and err are OK. Thoughts?

I think it's ok to set it no matter what, but I don't have a strong 
opinion either way.

Thanks,
Tom

> 
>>
>> --
>> Regards/Gruss,
>>      Boris.
>>
>> SUSE Software Solutions Germany GmbH
>> GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
>> (HRB 36809, AG Nürnberg)

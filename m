Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E35B5F27F8
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 06:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJCEP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 00:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJCEP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 00:15:56 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE982DABB
        for <kvm@vger.kernel.org>; Sun,  2 Oct 2022 21:15:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyCMWwllsyimWzkfbNckWJGMlsgtPcX+R/f5r1sAVuTRJTpRuUBQgash1WWDTpRyoG/thiYBsl54ogF7bV8DswxmgYnESsY2yCfRwUse4uX7PzGgsjraXLxirORLN8haZ+fpR0YveIcLH2FTelmkEAl5phclxpuFi3SWmGjl/KRh48sooIKN8YsfopSpa1MGC3wl4lGX8PIfYJsj3fnQoNoCob/e9mms3VFSEdsXBFlq43bCOowXOlpEk27azjfqdLSfLDxUNZlNDJdglvNfTLbkriTOFJuhjiBKBTow2ppw4dYL50ZOSHXe2UdgJscejENC8/mne3aKhY1SnBVUIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+BmFU37vdl42ObmeRJ5CuKTzAa1TMoDN+sDanx6RHU=;
 b=E1PmlZTgRTQNf3hV536MHUO8Uo413roRaQ/nPxCqBTNKzwG3HS9dfkxfvq34BirMvJy028WKE3eBevjZRa3A+WaxNKkj9hBgboeU7mwqPvznDbPDTNw0RmuYRMBnv/JSa5EmnQBhBbgHulFyXOEvkCvisqH+U8siZuj+LvkF2WeAS2INvIIz0YRLCdF8BIzahVHjV4XTgFvI9xtWiKRgiFb0x/yuKxkkEw3sT/1P/un+fUCktBuBglqYpGLkONXm/T58fTy63MNwpE0tPODsF0jBMU911UETtqe6hlwJWc0y7QXLp3CIGxD1a00Tsf8sTYF2Zq1eIqjJBP9RksiJag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+BmFU37vdl42ObmeRJ5CuKTzAa1TMoDN+sDanx6RHU=;
 b=cuvoCxB8S9395cEGaXHki9nfAji8ROnUJAMJNQ0wVCgGPbTyRGlixlxHMVsESnwiOYnLNuQZIhek5hj4+4kl0II4jwPN8GstPF/X6iHIPQ6SkDd35oj2xZ/a0fkXQK3TqVuzLdWbOSahcPZ4Z4CPgG4fC7xoaaD22+B2mA6SHzk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 DS7PR12MB6261.namprd12.prod.outlook.com (2603:10b6:8:97::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.28; Mon, 3 Oct 2022 04:15:50 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::1d66:4174:a038:a9d2]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::1d66:4174:a038:a9d2%7]) with mapi id 15.20.5676.017; Mon, 3 Oct 2022
 04:15:50 +0000
Message-ID: <23878d4c-52ec-9a07-1189-7a547ec9c9d0@amd.com>
Date:   Mon, 3 Oct 2022 09:45:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v2 0/4] x86: nSVM: Add testing for routing
 L2 exceptions
From:   Manali Shukla <manali.shukla@amd.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, aaronlewis@google.com
References: <20220810050738.7442-1-manali.shukla@amd.com>
 <d62703a8-7c8b-eab4-cf35-bb520312d0d9@amd.com>
 <1b17bc6f-c7c6-2d3a-476c-7cf0ea24f4cc@amd.com>
 <bae31123-27ae-5996-affb-93a7199a66f1@amd.com>
In-Reply-To: <bae31123-27ae-5996-affb-93a7199a66f1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0062.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::11) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|DS7PR12MB6261:EE_
X-MS-Office365-Filtering-Correlation-Id: abe68378-7013-4840-3de9-08daa4f5f434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2IWOedzgAByQbFYfz12+yJiulL3pYILp2PoxB7AgdO0F4m3p93UQfe8o7tvh5pKsJ14Lvn2oNeQKPySUvvj9+R/RtxxlaBmfpcGlvBdRCLC+rUCfGOjEk60LKcPpBUbsbDkLXUInabS2ZBp4Q3t8hwRofF3jyWYsqdMziDzalQ/9ZuiL1O7f367UWk0BAzF/5pjrSXzJyrpfMIYYXnAWpQo3RDdI0FnvlAm/80tk5g4pQtxyfD88aFfdeE8z0ck/TjlMotJhxEyE0Mp59Vy13IP3bKu8Cu2kYSrAtzttf96QE5Il4UrWcd6fctJrOPKO8hRh1wlQVIwIl9J5W8FW0mUYwTmnCS6cEzBaBSR1m7Qznszo/PozuF1h8xYkWBkGyKGPfenRy50zFQW6+blEKXkYMu09nRDSIau8xdJeEUEg+nmFI/tdlBIsGxF0T2sDXofBDyAt311AzgjUThBn26Cus3Zbb0zqWa5mAUYpqXivn0kFtJKcZO+u65NZdr2KKFRH1PPBdTYtHiQKcgPbU6KhLI3ybkuZwVEgLK1NlEHcq9ccA6DAKESZ3ksFDFcI2VjogttNZW6tH3ci1RyopsVD/oGZa2TkflcMzD326zV8UfujC+9oUGNolMOJTaodTh8Lf35LY8Oxz9YaiL8b8c08NnzDhdCQ65sJnpcqyxLAvwBIDgXtDXIFZx7faOd1kYZUz03wuSRfb6FtL8awjchOBTdpM8gv2wjlNxISQNQAq/U5A5Mu2PUu3BPhIvcvMYn2NNFSx1Rgea9XPO0/8HQxzQgJ3NTbSJv48ELxo960JZOazao4NuqsnuCDI8Cmpan4ZLukOPHkHOFqnHEcnviTfnIK1dYD/BtW0RvCek=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199015)(31686004)(478600001)(316002)(26005)(6512007)(8936002)(6666004)(66946007)(186003)(966005)(2616005)(31696002)(86362001)(6486002)(6506007)(53546011)(66556008)(36756003)(4326008)(2906002)(8676002)(66476007)(83380400001)(44832011)(38100700002)(41300700001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cS9SU2pIMEpWY0swRlBKbE9ZQk1OT2lmQ2VRdldVTEtobStnalhsa3paZ1No?=
 =?utf-8?B?WmJaT2Jxa2srOXgvamY2ZFVqc0lPc3JwY3IrMzQ1QzRrM3N5ZGdJLzZMYnVY?=
 =?utf-8?B?VmdBcmtreTJicEtmQ0NsYU02OG1sNk1HUlVVQlFRaDU0b3UzTGp1Q2F3ai8z?=
 =?utf-8?B?UTZTSEU1RFFWdzBnQlRhVGdwcnp3QUR6dW5Sc21yaEJjQVdZcVNjNlNnL3Mw?=
 =?utf-8?B?bXdNRHVCb1c4ekgzcHV6Nm5WdnlMWlM5bng2d1l3dDl4U0k2QWtoQkM3WTFt?=
 =?utf-8?B?VGFLK1F3MmwyN1lzK1J3ZXQwdlhONlpmTXVmTU1HSkMxQUg5aTVVYU9qanYz?=
 =?utf-8?B?T0UzWXZVOHRrTEhjVjRzSXB4K21VL0lBcWZuaDhtMUx3ZkJxVkgzSU1RUmo2?=
 =?utf-8?B?ekxMamw3eitTRVVLUjQ3UDhCL2VaK09SenNiYUVtTEpvakQzWGREaWhXVkFp?=
 =?utf-8?B?dWl4SzdBTFVJVHBTNDFrekJmcWxEdjd4UW1SWmxqeFhxSVVwR2t1a0I4Vk9S?=
 =?utf-8?B?Wkg0MzVLTnF1Ykdwd0ZuakVNeDdQYThEQVQ2S2VkRGF6MFJwWGJIV3VFUGJG?=
 =?utf-8?B?M1ZLZVFPRHRTOVFqTnovemZpQVRudFRLclo2eTdzaDA5NWhLM3dWTHllSXlE?=
 =?utf-8?B?REF5L1BpczExUjFpKzRLQW93ZGx1UXVQQUMxVE9Oak5VM0gyYUR6VEZRNzI2?=
 =?utf-8?B?cFpabFhReW9GU0ExamhXVzFsSGNCYUFxL3ltdkIrTmVZVkNjSEtGYjc1NXpS?=
 =?utf-8?B?TmNManBJSStXcmpLbHFlc1VCMjdCSU1LNG8vazlIRFcwRm1Na2FwanlnKzJ2?=
 =?utf-8?B?ckpFZ1hEeE81VGR6a3M5SHZjOXM4VzFhZTZCNG90MHhkdGJmMWJ0bnVRdjBW?=
 =?utf-8?B?SFFtbERpRk04MzQwUHVRVjQwUExDRFFQMzM5a0dSOFpoL0pCcUl2K0M0UVJZ?=
 =?utf-8?B?Tkd2OHI1ZHdnNWlZMUo5MnFrazl5RW5xb1J3TnVkUUVtTHZsUGtzTlZsRi9u?=
 =?utf-8?B?MDd4cVJPeDdGeUxnaG9Ta1dqa2FxM05oVnhwSFRjUjh6VnpVcEVpZjRjVVpC?=
 =?utf-8?B?T3lkQ3QvNTNhZFBBUnVEa1c2OTZHNzQ3RzdZb2NlZGRPMTJuOW40Q1RIcDYr?=
 =?utf-8?B?eVJuVUdMUEY0TUlSSk5ybUlheU91a3c4SGZNcWwyV0dFM2JzUFZDN1NDSEVt?=
 =?utf-8?B?VmdWVzFmZXl0azcyVG5IRXRzbzNIMEFRcE5UeTFGU2hJWUVhdHlhMkN2MWJT?=
 =?utf-8?B?ZWxTQzkvbDRPbFhzcDNKZWVpeWNnTEVCNi9iRlMydVBLSnlMU0twNm1xd0h0?=
 =?utf-8?B?eEx1cFlCU1hJcUt2Q2srMWNEU2tTMVVhNXFIUGdjK2gyYnpXSjdqdGNEM2NX?=
 =?utf-8?B?dUFlck90Y0tYUHN3eWNNcTNRNXdrcnhUZUNqcDBZZXRWNlNCK3RYcEtkc09C?=
 =?utf-8?B?eGptMGV2dENOZ2t3Y3hHWXBnN0dFSGhLWTNzMUNtaWNiZTYyMUkrVWNVREtt?=
 =?utf-8?B?ZlFuOWxPZDRkL1U4RnEvYmo2YU54bEpEa0NSbGNkVURhZG1GQmpKRThsczhJ?=
 =?utf-8?B?MFJwRTkzWVh6d1UzRDhnVGZsTDc4M3ltSXVQYVA4L256Q0J2Q0VHYUtKNEIx?=
 =?utf-8?B?S3RLWjlrcXZTV09wSEpobXNnU3pQaDc3eDFhQzIvSXA2TlpmS2tCOFBSOHRu?=
 =?utf-8?B?cURwNE5NMlYyMjFqRi9IZ0tWME00MmNDUklHaElHZnYvcGducVFoMjhaYWlu?=
 =?utf-8?B?SCtWa0hYSlFQR0M0TEhQOHhYWmpFQm9UQm03ekJYMU1MVzc5NVRQS3pxbjV5?=
 =?utf-8?B?Y1NoVTNwVnFHMHd2WHpEeWNocGY3NFAwK0lUOFp0ZnpnMGdVWmVKVUtkYndh?=
 =?utf-8?B?WVlhNWZja3N0UTlzNXZSRStvSEFqdGRIbGRVaVUxL1N6clhwa1JvQXY5aSs3?=
 =?utf-8?B?MFFFbmpuc2RBMGRpVkhJWFpVNnRXbnJ3bGp4aDVWdVdHOEtsOUplclVlam1F?=
 =?utf-8?B?Um9uT1FXVjRzSGdCYlVxR3AvNzlhdXYwUHVHWkNrUEZJb2xwY3Nlc01pZy8y?=
 =?utf-8?B?eUpmSkVKdmdvUDVBTmI3UUNXVGJQQnRUTHk0aFQ1c25uVFJVWFhTbENQYno3?=
 =?utf-8?Q?+eVg9WsXbDwNzV6lNxfd5Ow35?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe68378-7013-4840-3de9-08daa4f5f434
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 04:15:50.1940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4j4GXxUhCFNSfRAlTAhARoEppD499L8qVJlbJiE01EkYMYfn7hTdlR5RbhEl/hcjooM4Uh8dLekY52JX/tTBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6261
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/2022 10:04 AM, Manali Shukla wrote:
> On 9/19/2022 10:11 AM, Manali Shukla wrote:
>> On 8/29/2022 9:41 AM, Manali Shukla wrote:
>>> On 8/10/2022 10:37 AM, Manali Shukla wrote:
>>>> Series is inspired by vmx exception test framework series[1].
>>>>
>>>> Set up a test framework that verifies an exception occurring in L2 is
>>>> forwarded to the right place (L1 or L2).
>>>>
>>>> Tests two conditions for each exception.
>>>> 1) Exception generated in L2, is handled by L2 when L2 exception handler
>>>>    is registered.
>>>> 2) Exception generated in L2, is handled by L1 when intercept exception
>>>>    bit map is set in L1.
>>>>
>>>> Above tests were added to verify 8 different exceptions.
>>>> #GP, #UD, #DE, #DB, #AC, #OF, #BP, #NM.
>>>>
>>>> There are 4 patches in this series
>>>> 1) Added test infrastructure and exception tests.
>>>> 2) Move #BP test to exception test framework.
>>>> 3) Move #OF test to exception test framework.
>>>> 4) Move part of #NM test to exception test framework because
>>>>    #NM has a test case which checks the condition for which #NM should not
>>>>    be generated, all the test cases under #NM test except this test case have been
>>>>    moved to exception test framework because of the exception test framework
>>>>    design.
>>>>
>>>> v1->v2
>>>> 1) Rebased to latest kvm-unit-tests. 
>>>> 2) Move 3 different exception test cases #BP, #OF and #NM exception to
>>>>    exception test framework.
>>>>
>>>> [1] https://lore.kernel.org/all/20220125203127.1161838-1-aaronlewis@google.com/
>>>> [2] https://lore.kernel.org/kvm/a090c16f-c307-9548-9739-ceb71687514f@amd.com/
>>>>
>>>> Manali Shukla (4):
>>>>   x86: nSVM: Add an exception test framework and tests
>>>>   x86: nSVM: Move #BP test to exception test framework
>>>>   x86: nSVM: Move #OF test to exception test framework
>>>>   x86: nSVM: Move part of #NM test to exception test framework
>>>>
>>>>  x86/svm_tests.c | 197 ++++++++++++++++++++++++++++++++++--------------
>>>>  1 file changed, 142 insertions(+), 55 deletions(-)
>>>>
>>>
>>> A gentle reminder for the review
>>>
>>> -Manali
>>
>> A gentle reminder for the review
>>
>> -Manali
> 
> A gentle reminder for the review
> 
> -Manali

A gentle remider for the review

-Manali


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C977A5E9875
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 06:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiIZEe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 00:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiIZEe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 00:34:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C376A2AE1E
        for <kvm@vger.kernel.org>; Sun, 25 Sep 2022 21:34:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTbu/IzMUJdcqblV3tbNIkjPS2lsz1KUAP6wu1vNVXJhYAmTpZrKw1vhgux9uB4J4LqR1fF9w2daQKsRlSZQmuLfaaVPDOcRLQOUyuItIlLcndD3qrhoF4DHgg9IINZDvrdfXq3rkwh0LkZXIlZ2Crc6j74YtJ5JOIA4I35AbL8v/+uFxnKYUceet+OjFyoQX2tK1FSARtHklK+vuarM8g2FT65iSczphXjYdH6o8F1zioU10Kn9Jy85Z3t8o3Lm8uj53rMaeEU9S1hxU5ET+stZWXbTIOocJKDRLRf4lLP9Vblnh0j6R0Em4KhCKSOXeCAJw8EsfyYYa+OLnklZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhtIyO+xuLQYsykDQJ+BpZpxqpVDSk2EQS3+OZDQKY8=;
 b=Wygi8fllTn9IP5MaUz521yqi8wabYg4ivcbHon9hV2xx8Q34aKvRWUKwOc5S+QAfyXUa6rzMpyvNOBy196ape3lI1iRz3NeyoT82tvmlrXAg2PqVA8F8pkxMEyGZD41pCDGDj3YfqWKBWg4EzFU8P9FNicObmSzrbbrNMzQ1UDR6pFAFlr7CPOV25gHaLJHf1cZVroq+ctrdBDgNa62NiDjYnsOj6dCHeoeVkri9ZMTI4LsQYOpY4LGLGZuzjD+Bm9n9yvpngMWsmKGg4hLvCLrb8cKuDbTHFnCdEDaiQZHaIO9HQmt0dSlNP59dcRHrtYKiRcl9gSZ1Ox5yeERX4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhtIyO+xuLQYsykDQJ+BpZpxqpVDSk2EQS3+OZDQKY8=;
 b=WlXWNEYNRnrOsI08sk5h9cFJoHyNuU8sOVSFvTlQ3xUPFp2VwwuUtB9943cDbDfMgaCuCHQ3EptgO60AdJznUntsugNKU8DGDWOmov2EMi7rqyvOMw1ey0ie8KiCur3NDBiIw7LqT/P62dWTsahQntjjEcMKpxltq1u4AwHjKGA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 SJ0PR12MB5488.namprd12.prod.outlook.com (2603:10b6:a03:3ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 04:34:22 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::ddaa:b947:3e9:ce72]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::ddaa:b947:3e9:ce72%8]) with mapi id 15.20.5654.023; Mon, 26 Sep 2022
 04:34:22 +0000
Message-ID: <bae31123-27ae-5996-affb-93a7199a66f1@amd.com>
Date:   Mon, 26 Sep 2022 10:04:11 +0530
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
In-Reply-To: <1b17bc6f-c7c6-2d3a-476c-7cf0ea24f4cc@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0238.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::8) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|SJ0PR12MB5488:EE_
X-MS-Office365-Filtering-Correlation-Id: 912ef814-4521-41e5-6b47-08da9f786249
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hpkPF+riHaPqWykQ5AkqCM7UFfp38FFhrm481PElumTtZENH26Z4MkrOOYrD2lsWmmBL5UpkuJOamn0xIXPjitx0X/uqIkuS9ohDGAYxJy8OJdHcQVCBLkQFR7cD13GVb105j5R5E2cKSTPjADdsEBtYF+T0XtDa37qgDwhKEFTtsdE5hlanoOvqMR6rJOTaKcEN5NiBP4XVFM51DQ7qSZyfQv76d81KK+1DShCK8D/BzGhTJxzEWKLY/q9/7tHlExVMhc+eCcRr3iDMQ39nUe2LXXMJdHGwrbFj2S4nOR+UHCr/YKJthqW/NpKd1FAR4XuI7SBwoyiLh8myUKNsJn11E2aVdpd5EmiquZnhZAiySuN07jt3oZReU/n0m6GiJ9aIG70FnKwezUZb147yxwWJhUm8tESmXLi70olGom7e8ZCC9krOAQFBrMwlTVP8qvjZ0HesnqgAiyorhT9Au971GkSMlkPhOv4xn0Tz5AYIqAVN6YbjyGif961Fqbi2f4+zVO/fmgIYXbMaIpN/tptBihpGjBz6A3dczHOJO3SlObam4+Su5jnIwHkp4ToO5dQ6gl4FJOxXqeGeRNaw8aGTRDXIiXiegxn2DuSYuLsosfnC4EDojzJbUlZufmPIfBKMwE022U27QzpAccMSu/ZnsFe+UDEdQJf/MSeHTCio/Dt7vPmZa14oMTaitYrv1d0YW7cxBMIjnGDvfhcO5PLb/tb4PkhCMIdKl8kpvdA5ER4l02HV1TI2gS8wkTGHCyVRLrX4000eZlSV6UkA6IE6A9/yolNM14/0H3Cb8siZdSLArXIZwy2ObjA1VbSISErKwieyfzxqeNXVoNLFLVOmCJ3ZMFDNGaXTuYThd0b2d9O5JV1SZdX2Q/TMbzbf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199015)(31686004)(966005)(478600001)(6486002)(2616005)(36756003)(316002)(2906002)(5660300002)(8676002)(4326008)(66556008)(186003)(66476007)(6666004)(6506007)(26005)(6512007)(53546011)(86362001)(83380400001)(66946007)(44832011)(8936002)(31696002)(41300700001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEFsNGxXWWdQeFBRakhaTEtEcVBrYjVqZjc0UnFSZDVkdWQxeVl3RVJ6Ymxy?=
 =?utf-8?B?ZmxyS0NWaXNsZjFoQ3pic0t1b01qdTF1V0g1VzBZdDRWUVRuNHlWdW9rWkVE?=
 =?utf-8?B?SnhtYmJqYi9TRnViMGNKdHdmWUtRVGZyMHlaMVhldWNjb3lEUHdIeEF2YnZE?=
 =?utf-8?B?TGF6UmdlbjdrYWRYOUtlT1pXL3V2eFdRRUZ5NWxiNzIrRTNYR1JBNVc3ZWtJ?=
 =?utf-8?B?NWdEMVlQTUxPVy83cFVXWWQ5ZVQ1aGpwMnlIU3hVOFJIYUNxN1IzOGljaHRm?=
 =?utf-8?B?U1UvVXB6NWRON3pVWm1abmxXTUdXdUZENjVjS0JaUUViYllqbi9UV1hpTDM0?=
 =?utf-8?B?elF6eUFRT1lnaDF0YmRlbmdZN3NsN1Bubyt2OXBFNDh4VG13Q0FOdE1iSUNB?=
 =?utf-8?B?TU5YaGNHaVZOZnFFa2x2SHZsaVpNWHRBM0ZuTzU5QUZmai9Wd2dhcXhaQ05T?=
 =?utf-8?B?VHlEdU5ab3BuUHZYdk1xOHNINjJUZG9ibGdpand5MG1GemR1ejFwZHRHcFN0?=
 =?utf-8?B?eEk0YlhNOHJJOE16TTVRZWZqWlpTSGczVmtSb256aExnR3RpYS9VOHlpcXp5?=
 =?utf-8?B?dXdka2ptWWNzWmxnMVNuUi8rOVB3QngzdUg1dlNoeVh3MXNlNGlsNVBsZ2Rp?=
 =?utf-8?B?RStzQWRDRmhTYXAzYUtjR0wxdEZPY1lrNFc3YmN5M2diQ094SzVsQUdvOGdS?=
 =?utf-8?B?eHBqazBYemE3RFVFSEFsZWFzS05rMWppRGZmMDJFYVVkOG9GUFlCNVVnNVh3?=
 =?utf-8?B?Rk5UdzBqMkxvREVEazNOdHI4NFVENWxhOXE0OGRpYWRrTWhtNUhlMlptYnV4?=
 =?utf-8?B?bTk1NkcrRFNZbzFzR0l0QUV1azRKLy9ha203WXNwNGRKb2toWkd0L25zcGNa?=
 =?utf-8?B?WlBHa0QvZ1ppWmtiL1lRN0NFUUx0N2MxUUtsWHAvNW9kaEwzeTFBTURjREh0?=
 =?utf-8?B?RzRBUktRcVAzeG9VTVpObmQzckRzNm81aVF5V1FlVXdZbHR6MURRMkFpRko4?=
 =?utf-8?B?clRzVlgzM0JNcDFXWkQxckRpUjI4Wk9jVzVjcEZlNDh5WHVPQXpGeGRiYUNx?=
 =?utf-8?B?aFFGR1h1Mmx5cGd5VjFNMzMycEJ5SzhXWUsrbjVDTllaRXFFZFk5bk1PdVdN?=
 =?utf-8?B?czNLdmVmTjNvQUVQQ0xkYlNQc1dqcEsyTVZscWg5V3BNTmw5Rk1MYURZYWta?=
 =?utf-8?B?QkJUY1NHdDFYcENXMERtUWlxSTlOSkdvekdSNmJNMWxrUmUwN1VuSExSSFEv?=
 =?utf-8?B?b1Z5RmtKNjZNK080bFVYUlZWNFBBbnZSc2w2Qk1mdFMyZW9HUHU2ZmRtSkRX?=
 =?utf-8?B?ejcxa1J6bzNyR2h4eGVPalh3Zjh1eDQveDhuN2VoZE5uZmhDVFBydmlXb2pp?=
 =?utf-8?B?TTJEaFVVRmdaQ2V5Tnd4eXFLQU9BV0hUVnJKOVF2Q1lsTzluSWVnbUZESW9U?=
 =?utf-8?B?WkRnZmhRdVU0YWsrTVBFTUdJS1ZsSW9HUDJPSXNyRXE2emZOMGdYTUxjVDZz?=
 =?utf-8?B?WkpkU2dOVTdqMUJrS0dCcVMrSHAzbzBiVEVFUUFKNjVqNzZUMG9kdWU5aXM0?=
 =?utf-8?B?cGg4QVhvR3ZxdWIyaVU2ZlVoMFZZb29wN1o0ZG1yTThqeTkybTJROXZBRE03?=
 =?utf-8?B?alYzaHhGdUZ0YXNzS3hnSlFFaHhvc3pFR3FFUmVoUEJQdGdBa3V5aGk2bldj?=
 =?utf-8?B?ZGc3NDc1dkhuTHY2UDJJb2IydjNWL2tCYTNMSkZOZEdPY2lLaTV4L0NnajZI?=
 =?utf-8?B?ajVSWGVDYUdPL3R1YUpvMlZFMWg5MFQ4Uk85em1uRlhZb2h3dDdPZVZzL3VX?=
 =?utf-8?B?bWhkNjgxQURHVHZ3cXdYOWprUjFNMi9jQ0JrY1VpakVVblFacUc4NDE1WmpJ?=
 =?utf-8?B?R0swaUFuV0dmaFlQbEJQVlp6eDl0T2dxMU85SEFWSmtudXJOQm51OFpuODRP?=
 =?utf-8?B?OG15UHh5K0drR1F6KzhBWDlZZ2wrSWtjeXoyR1F5V2FzYk5XK2s1eHg0Umdk?=
 =?utf-8?B?WjFFUEcxcUxtTDlLMWtDUzJVZmtjL2V2b2tyc3NRL2VRU01OUVR1NzkrS2dS?=
 =?utf-8?B?Q0E1aUxJWnRPSmxycHczdnpQOHJmVnc0VEhEQ0Joa1JJUG1GOWU4dllLRnFX?=
 =?utf-8?Q?eVXFxjDPt32iFXoJHtGZAhRz3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912ef814-4521-41e5-6b47-08da9f786249
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 04:34:22.4135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WPJBPGfXmIJ5I89emFiazn66mmUzzwrkwp4C5mKYaCOHNeCpXhj5GNeroECd0hhAck/XsbwISCCI2jAQFn6N0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5488
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/2022 10:11 AM, Manali Shukla wrote:
> On 8/29/2022 9:41 AM, Manali Shukla wrote:
>> On 8/10/2022 10:37 AM, Manali Shukla wrote:
>>> Series is inspired by vmx exception test framework series[1].
>>>
>>> Set up a test framework that verifies an exception occurring in L2 is
>>> forwarded to the right place (L1 or L2).
>>>
>>> Tests two conditions for each exception.
>>> 1) Exception generated in L2, is handled by L2 when L2 exception handler
>>>    is registered.
>>> 2) Exception generated in L2, is handled by L1 when intercept exception
>>>    bit map is set in L1.
>>>
>>> Above tests were added to verify 8 different exceptions.
>>> #GP, #UD, #DE, #DB, #AC, #OF, #BP, #NM.
>>>
>>> There are 4 patches in this series
>>> 1) Added test infrastructure and exception tests.
>>> 2) Move #BP test to exception test framework.
>>> 3) Move #OF test to exception test framework.
>>> 4) Move part of #NM test to exception test framework because
>>>    #NM has a test case which checks the condition for which #NM should not
>>>    be generated, all the test cases under #NM test except this test case have been
>>>    moved to exception test framework because of the exception test framework
>>>    design.
>>>
>>> v1->v2
>>> 1) Rebased to latest kvm-unit-tests. 
>>> 2) Move 3 different exception test cases #BP, #OF and #NM exception to
>>>    exception test framework.
>>>
>>> [1] https://lore.kernel.org/all/20220125203127.1161838-1-aaronlewis@google.com/
>>> [2] https://lore.kernel.org/kvm/a090c16f-c307-9548-9739-ceb71687514f@amd.com/
>>>
>>> Manali Shukla (4):
>>>   x86: nSVM: Add an exception test framework and tests
>>>   x86: nSVM: Move #BP test to exception test framework
>>>   x86: nSVM: Move #OF test to exception test framework
>>>   x86: nSVM: Move part of #NM test to exception test framework
>>>
>>>  x86/svm_tests.c | 197 ++++++++++++++++++++++++++++++++++--------------
>>>  1 file changed, 142 insertions(+), 55 deletions(-)
>>>
>>
>> A gentle reminder for the review
>>
>> -Manali
> 
> A gentle reminder for the review
> 
> -Manali

A gentle reminder for the review

-Manali

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C640693934
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBLRzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 12:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBLRzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 12:55:06 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD90BDDF
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 09:55:05 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31CAR7Xq002678;
        Sun, 12 Feb 2023 09:54:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=AWvT0xYtEU0XRTwM1Zg1AMlQTw4jM9cmVT3gSR6VEIg=;
 b=ydcCv4yIQGKxlnlrj5zeKF5vA5BmYMZAFPeH2I0XWUToav0ooKDaZcEd95uSSrFHFurj
 782ixyEINjydLD/jwKxle5X1k7HNPL8uz86Bnt47Set6e2FXeVu6jZz867L9hYJHJZGJ
 Ezi38Mlaxw3p8bOg6wLN19sAPUX3NY/pvGPODsjLKz5UNhYZgE0/UGpmcM7h7UPexESb
 A8tdV2cjEkJ5VQ70wdScWItLn9vuASeAp7EYl3y8BxXkkNw1ljv8j4Eij67+8wKjkN0h
 O5sWVjqIy405bxqTrj8L5lP0Ka9bpTNJebE9SXSDCC3W7IPQnpB2vgoyhf5gNaC4e0BZ ew== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3np7tdu19x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 09:54:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdXIR0bt7irSvl3mav6PyOdNs/HbHiGSxwRnUOFAdSTOxqotHv1dN78du7T29CL8Kh1nQlNeNGRRNYM7H4QQIpuZURE5SnPwCHoXZ5lcgAVE4feSXy/rH1yOAtag3sbggzHuUIut7bXzoBMttPtTJxcigAl1z9awJeSFDIHhERXuIJhqDW+bTuxKk9FLt6yYz64q3EN46EZoDagA3AOtkVxQUKdZ4Qqx6x+qCpUek8k7zSyw11dT/24ZvBjxOGk6q9CSbSVRoDx04w9n4SrAXf1wrObOHAJxYA6S6UCYURORlG7Q5O/uaY3G04YbGdI6X7x3FyuvVZMz4pU4VXPc5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWvT0xYtEU0XRTwM1Zg1AMlQTw4jM9cmVT3gSR6VEIg=;
 b=hinl+yWWgTGt9l3pJL6wWq1je7QOhxKaqCqWi2JCxL4TkSh86cPAHbeHtDT+fPra1uhs6i7sE7bS8G3HhLYBvSqbWU6wesNg3f6OeU+OIVnFSjPz3kNjKJ1pWAKXbkIzDSR8/YcPrUI9KV0yTYdC/eX6TjgWsQnYx7nOcJZDMhUlqU6zqrRHIS3Lp4AOCy0+zHVkkRoV0NBK19XwPYmSwxpzrdMwSnvdOo2Ihy2kbDVE/M96yZxzihNxwU/xeFMh8yUb7z1IG40Uxhg5I4WDQhiV+t1a3uSN2CAxnqPM3hR/issBV7MsbrNGlTXGYjGITwJXHSSzuxcMin2Wumc/yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWvT0xYtEU0XRTwM1Zg1AMlQTw4jM9cmVT3gSR6VEIg=;
 b=hAi1K6uuspcKnTkLV+NCImBV2A43zQgpPckghIBBcd9ZLcGopEW6zS64kt4eZs5kAeZUsWPDGF7cQK1o0tQG1Ies7SvdQxcDeKXGcABCnIHQ8RPTOKB563Epc8NQpSGuQF+Hh3whOYQ1kLhtoplMPS8MxJohcDQ1AvcHXdvbeqNR6fCzAWSHbjIcB5rZCORqF9FgMMWbIaqcWzJqOKSu5bmda18tHyZ4nPCe6j9SuZxMwxXmNfRjIMW41Ax4lIfwWcnm+OMLWjgnmHo5Oyuz7IDxff5zt3z97UHqs6RI3x4zPdyN5bSIAgblhTw4p4tMazi8sN8XUeO6pNzSeqRtXA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by PH0PR02MB9383.namprd02.prod.outlook.com (2603:10b6:510:289::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 17:54:44 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%9]) with mapi id 15.20.6086.023; Sun, 12 Feb 2023
 17:54:44 +0000
Message-ID: <4b81ddf6-86ad-ef34-3cec-3fcefc796b1b@nutanix.com>
Date:   Sun, 12 Feb 2023 23:24:30 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org> <Y5DvJQWGwYRvlhZz@google.com>
 <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
 <eafbcd77-aab1-4e82-d53e-1bcc87225549@nutanix.com>
 <874jtifpg0.wl-maz@kernel.org>
 <77408d91-655a-6f51-5a3e-258e8ff7c358@nutanix.com>
 <87r0w6dnor.wl-maz@kernel.org>
 <4df8b276-595f-1ad7-4ce5-62435ea93032@nutanix.com>
 <87h6wsdstn.wl-maz@kernel.org>
 <8b67df9f-7d9e-23f7-f437-5aedbcfa985d@nutanix.com>
 <200246c2-9690-dabe-279e-13bc9beb711f@nutanix.com>
 <87k00mlsik.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <87k00mlsik.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0005.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::16) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|PH0PR02MB9383:EE_
X-MS-Office365-Filtering-Correlation-Id: 840ff03b-9b1d-410b-3e40-08db0d223895
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PTbHzR6lsnVdhp5EnUr/hWvSY21LSYoHSkpKLSHdhMC2RAWBR7+pHG+r2Lo2bpyIDz3K7OcsqklFFeNYD/ALBQZ7WoMDi7kVh/zYpWMpx2biysviJ6DtvSlcU8rr9x1p3yntdTu8KtY6ceZbZ8uhBwysMLl81T+AKdAjxv6UL6PewJKca7l9++U3FtLNeYh/1IuCNnB/kxFXxIcsrGb424nwnvN2Y6cbXHzq9oIdOax/nxiima/K5W1UBfiTGG3uIXtrC0IxAMqFR00stYGssKUVTj0+Kk+wUweQWS9GdNt3awOxvBO87z1IoHKt2giMYzCfQBwHTaF11DbsUjXr+//HIvUHDniGtgTxe0ypVnYSjbJmHCJOrqWoX7MloEvoBjg0JWV9QT2w48tH6c5jAu5FH1+dPFjQTdxT+HbFOE8mU7mSZdyqOYLfXwVggz2oNZCYGAj25xi06+PmCAGNcXkk271YmeQGychpCn8NLrtI5teyJguGxg+uk2LgxIvAdFP0eBmxt0UQ/ZOVqO4Ud+ISEURENC0SoXoGAYInJWQmyHrVg+8sl+V4dIV/0hF+phgNT3js0EBBoas5U3dzsP1ziZGC1wgumwfmypvw8nWWRhXh3qsV5vURGCJ/vlUWrW65rvEFc2PDvDRYDqfPTFUUPHVOusE2AjYDGSwpmStMevbMA45jUQv9XGdBuCTl3pYcxetTWBp+8yPGDopGsN7zrFdFXriiv8Vo91dBS1J+hzzu5eUaEfVv3ZJvhYW0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39850400004)(366004)(376002)(346002)(396003)(451199018)(6486002)(478600001)(26005)(83380400001)(36756003)(38100700002)(86362001)(31696002)(6666004)(107886003)(6512007)(6506007)(53546011)(186003)(2616005)(54906003)(66556008)(66946007)(316002)(6916009)(66476007)(8676002)(5660300002)(41300700001)(8936002)(31686004)(4326008)(15650500001)(2906002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3ZlWGFYMmVCM1lqWC85UXBaU0JlaEVteUFhMlBBTWtKY0NaSXRNcTdSbVpT?=
 =?utf-8?B?TGtiVHB4NUQzUjVGWXF1Z0FvSEswcXBJSC82Z2h4cXREZURaN091RzJtRXk2?=
 =?utf-8?B?UkQzQzF0OWNYRWpjWU5QdS9aWXNxY3IzZDJqT0hyTlFNb0ZaakwvVDhkdDJi?=
 =?utf-8?B?aGVqS2pwRWlqaEZpbHZNV0xZM2Z3THpoV2lrb1ZhamlXZFZJRVBUV3lmMHJx?=
 =?utf-8?B?Ymh1UTZZendOOHg4K1FnUTRQc3RxZTVGMlF0ME9kbnZTbU1LZitQdDJHWHBH?=
 =?utf-8?B?N1l4U0tTNkcyYWI4TFRpcGVjZ21KaWhpaVpvV3VvMjZ5UnpscXdZZU1ISGoz?=
 =?utf-8?B?K1NCRG5UOGZSSDNaUFZMVDRRZkhkT3JvaCt4M3BHc0xua2hFa0FudW4wclBl?=
 =?utf-8?B?NUlZckVkNlZrWUZoOXlYMXZrWUswVmNNN1JWTkdrdnNPb3RIYUFsWUh1Vi9F?=
 =?utf-8?B?bVgwRzFCVGEyaEhkaC9sQzZXakhJeW5MRXFTOUtYZVJiYnZmcnUxUTUwODJH?=
 =?utf-8?B?TCtNOE9xNlJzMW0yaUNHd0h3cDcrS2Z1TDdvUzNUd3BoT09KRmd5VHViRTha?=
 =?utf-8?B?UlhQZEplU0tsMjliWHp2WkFSWW5MSnRJVU1xZnZhM2tmQTIxbHpyL2xQL2FK?=
 =?utf-8?B?N204MkQvM2lHOTl0SHh3Z295bWpCUUNBdnFLc092emE3WjRnUEhDdXVXRVhR?=
 =?utf-8?B?RGFveCtzZHViZ21uMG9JQkdva05vdlBSWXJscklUSTNXcnBUaGp0UlRFbWNK?=
 =?utf-8?B?dHo4NkN2WTFVN3A2bGkyK2ZERmN5bENZejhiVlM1V1Y4dkIzWGNpS1ppcW5T?=
 =?utf-8?B?SkhWc3JKbEgrUkEzalIvRlhndWFBc3ZLMzd1YVhBZjBIdTNqZ1JoZEVyMVg5?=
 =?utf-8?B?RVE2VkR6cE0zak1NK256NFFuNExHNW4xZ3kvSlBMc2ZGZk9zRDk2aWdGcWtZ?=
 =?utf-8?B?c2lGQTh6QUEwSXM5SlVDUjlidFNjK2MwRW9GZC9IN2xoN0pzWDNiTjQzNE93?=
 =?utf-8?B?WjFaRlJGNTJEZDVLcllIMHRNUGNwcmEwMmtpenRsWWRBZDFxMld1NUR1OWp3?=
 =?utf-8?B?TCs1MnkvaHhKTEdLYnUrQ3laU05ieWV6QWhmOElpVFdId05sMGNQOTFPa21H?=
 =?utf-8?B?LzRRZk1YZ3VnQnRFZ2o5ajB6VmpuV1BnZitEYWRhVVZodmI3MXJlOWN4Z2to?=
 =?utf-8?B?d3dSNTZNeVJLMGtYb25adFg2bDU0b3NQejgyYk1wL3J5T09hTnozc3VxdFVD?=
 =?utf-8?B?UXpmZWtaMWs5cDUxY01VMHVNZE10SGYxWVlOMHh3b0xPYlB5SHdjNERyNms1?=
 =?utf-8?B?SWhnQTEyZldWUGtXdnFWYjRRY2M4RE1OTGRIMzRqL3YyeHJLd2dMRlNNWW9x?=
 =?utf-8?B?am12ZzF5SXpOZ0RwMmpDd2E2cGtNcUwxWmkyRGJvV0pidTVwRDBJcUxHeDdQ?=
 =?utf-8?B?R2tCbDZoUXF0OXJVMGlSQkFpUmVVa2hDQ3NZblFiZVZoTUZHU1k2SCt0enNk?=
 =?utf-8?B?bDZhMTdmRU5DRWgvazE4dU44VjFBU1lkUFY0VDdKenBTQ21sZmdobWRud3JP?=
 =?utf-8?B?VVRocUFoek1RWEtIcis4RmkyY29pYmthN1o1YXBUWk9HeHVDM2lINFhlejVW?=
 =?utf-8?B?MXREYW9oeW5KUnVVRDZKVlpGNUdxUm15cmtvTk5lS25Fcm5XYzdERTR5dDly?=
 =?utf-8?B?VlBDbHZtUDJ4YzAvZVdFdHd5RVlXWm5WTmtuc0dUekg2aFNLbzZkMVhVc3hl?=
 =?utf-8?B?bkhPc3lhcmpnT1VNRTVEVkZhajA5Zk9LL1lkN09Lamxob21ZV3J5UlAzZklU?=
 =?utf-8?B?Y3RrMDYrcFAxRHRkcW84NUxuUXZlZmhpT081T1ZtR09tcU9pdldxeTRha2Nh?=
 =?utf-8?B?MTFldFVNZW05aUdVRkMwb08vYlJRL0hkaVZkVE4wSFFrTjQ4TklpNVdDaS95?=
 =?utf-8?B?cGZuMU80eGVDcEFRS29YUlNka3N0SFJaYWFBbEREaGp5eDlaYWJUeENPc2Y5?=
 =?utf-8?B?WGVabm0zTFlLTFhxUWJDR2E5bUFxYWdTNlByV2gwcXZNcjlzdUtNQ3VVdkNR?=
 =?utf-8?B?NS9Wb2h6clovREVPaE45L0NTdmRGaGpBWG5lY1REU3kxSklWNHBTNjNjTSth?=
 =?utf-8?B?ZFk3SitsM3FvRzZJNUMxOEVZUnZCM2tGUzltaG1aU1BBamdnWWJidS9lVXNN?=
 =?utf-8?B?Rnc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 840ff03b-9b1d-410b-3e40-08db0d223895
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 17:54:43.6316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rdKfUGa0c1PCThkIrOIDPO0DXPvJXpQcGUE0dv2tQkQNosgWtk+ur4O/SlsV05f8sjhQBxBoKN7ia25BsLeFpHMWujb43CJQDTkNM58bA3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9383
X-Proofpoint-ORIG-GUID: jjbmVmU2V5dtFZrKwfCz4Pa8FlyvmRM8
X-Proofpoint-GUID: jjbmVmU2V5dtFZrKwfCz4Pa8FlyvmRM8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_07,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/02/23 10:39 pm, Marc Zyngier wrote:
> On Sat, 11 Feb 2023 06:52:02 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>>>
>>> Hi Marc,
>>>
>>> I'm proposing this new implementation to address the concern you
>>> raised regarding dirty quota being a non-generic feature with the
>>> previous implementation. This implementation decouples dirty quota
>>> from dirty logging for the ARM64 arch. We shall post a similar
>>> implementation for x86 if this looks good. With this new
>>> implementation, dirty quota can be enforced independent of dirty
>>> logging. Dirty quota is now in bytes and
>>
>> Hi Marc,
>>
>> Thank you for your valuable feedback so far. Looking forward to your
>> feedback on this new proposition.
> 
> I'm not sure what you are expecting from me here. I've explained in
> great details what I wanted to see, repeatedly. This above says
> nothing other than "we are going to do *something* that matches your
> expectations".
> 
> My answer is, to quote someone else, "show me the code". Until then, I
> don't have much to add.
> 
> Thanks,
> 
> 	M.
> 

Hi Marc,

I had posted some code in the previous comment. Let me tag you there.

Thanks,
Shivam

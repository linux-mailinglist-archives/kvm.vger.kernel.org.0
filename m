Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340A8606260
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJTOCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJTOCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:02:13 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D1018B09D;
        Thu, 20 Oct 2022 07:02:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5Z2cnbfk6+TqD0AWrp9ljkS++ShJdbJ6xXij2JOcFSKpa9q0Y63HJrN/5QzMPVH1pqwvaQSqJ5kS5bPhjtJ9uZ5cXwOKaySw5kqQ9OyUQiJdODR40bVLUHAbqgjwFQ4WCIxIBpNft3NC69//3tty8xVUi0fkNqAuhHyp0YlOVT8P4f9HTTfDUEgVjczh5YRBMDKswFNUAdp/BREivO3eS/lPcqbPuC5ZjF5Emk8djdD/5O6UKynneoXx7qhTlp9oooIpwUJkJ3KvuoqkEf04z8OYkoEpAOnF8JAV76SFLAo4fkUa8+m6d/Zhh3fXAmtfDVbBBg7GxyyI+eMseRbjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8cXcVKoHdNpgvl8Yk4XHrcdMHahLCqad9qZBoKcdReE=;
 b=KbVCJL61D3Ypfp0JcSWXACXiZsetIhpUSe+EgAo0nVbry/dSGF30GmX9nc4fsqrdtJPfsVSlb6tQsxw/YHO6ScIRuvPlaU7nfOMRvZRXQ9qgJsNr75fCSMeEzVOhhqHnsVkFTB6YAz9tsey8D5XsHBAeudl4FPXvQ5tMtYL80e822yFppuNCz8nVnKfxZ9FGm4gIK2nJQsImMASZ4nIXjNk1otsxzNlILvwe7Enre8GM8OLMYuh0qHcgql+0vQm1Km+8ysAgprVFl4z5JgAE3rLmzNc2NIxoFRiNOoEjhBeRmyMIJoCtdmwljBnAhdzuz/Aa8psJkmbccXTHb1+ecw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cXcVKoHdNpgvl8Yk4XHrcdMHahLCqad9qZBoKcdReE=;
 b=E5yTInwMrFShKqaIpM+ZKmGUqp0uHw3GVISARXhKvOKOxTWCeZuX4pdbpl2tkuCHgZEoQ92mFipvyU/uPMqY1U4c3zQVkFrw0F/vBxKN0g/2DvatXqEobWekYoBeKTLJFfVWsWYsiS+b7JFJ8+WstHdqRKLscZoJofJgUnRXwo0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 14:02:08 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 14:02:08 +0000
Message-ID: <195a9a2d-d758-e70f-335f-c394b0c587ad@amd.com>
Date:   Thu, 20 Oct 2022 09:02:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] virt: Prevent AES-GCM IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221019150333.1047423-1-pgonda@google.com>
 <528937ab-8046-d5d1-26ff-50ef35f5635f@amd.com>
 <CAMkAt6ritG1zmOreh9WYLYAGww0EJQy+m-Y0nfxD5+gpTkpJ1w@mail.gmail.com>
 <821e750b-26c9-3331-7577-5cb832a35afa@amd.com>
 <CAAH4kHYhLkiN7H03GKgMU+3h9rhp2a03gNFGLbrNtjp=PYYHQw@mail.gmail.com>
 <5621c2b6-a5eb-c786-afee-020e97c0e4c8@amd.com>
 <CAMkAt6pCPmf++Dg=x5bSN4-gR-s7BuYiryOGvGezLupFN9aEKw@mail.gmail.com>
 <948704a4-2348-041f-4f46-bbf42d985549@amd.com>
 <CAMkAt6rb-f3qCb7Np-SdHd7u87-zShFpYkWcA910uYXUafqtPQ@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAMkAt6rb-f3qCb7Np-SdHd7u87-zShFpYkWcA910uYXUafqtPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0194.namprd03.prod.outlook.com
 (2603:10b6:610:e4::19) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BL1PR12MB5048:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba14b15-05bf-4317-01c9-08dab2a3ad81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8KLyCXtR6chL8fny7e9FQcX/ijaBP39tRaEclP+a7dmx5F+ZrLnEcqZVKjrGJS+OBF5FBzXrOStFOM+rNtWEeRw8qUjc8Wx5X6JOIaEom2wcH5IYBylH1D5rrDtDCBxHmYs0p3y646IA+uPr5MqAyXAKabW5lCWpfiLz7dUxTFlHk16llJhgSxOQKI1hU/WTbOXBWblsdJb7f9Gu1uw8I8zT40P6QPPji6ySrIjNSSuWvAu4zX058Yh+ZbfpI96HIbb73/zlNeY777TLTy9D+Id+9JUMNf7sRZr4HlWd1A2KrCSr7JG0CzzzCysvjRMlLM1hdYPDW4HImLqR5ZiQZvx+qTdP6y1UUOkzOfdj8OOweDoLjFCk/87yNS64bvcWcWc/uyNNDkvChIpytWl7NrY8/VkX8pC00nk8xkA0jIhFMUBgpFgehQwzAI/u1tQfuOHllyH2Ss+7mwJcl9bM4usn6krfWVGz68rjAbuFwGYKjuuE8VB4tdlzlAmQp85uHpnXezugg2sjOWKuTQ4viMv8YlU87Q9pb4oBUWGhGaHZPEj+NaCJxJqWS3zw64jTgJuAdXuOeosc2LTrn/uCNk8jpNmSNFKBuQ0A1H/Chfdzrcym2qXMgUD4e8Gc2kH+8PeOFn9E17ylehsZ/onfm5pEbqzFYqtt++vir7YGQVW2I4Ip+tyjQs/GU8ivEg+LFmgWWyCp4XIknYck8B280zGIJeI0q91GsniM49Kgfony/wU/tqzts64YevSzjFl05wupQb7uddCDvxSwJ9DTRNT/7leoQ/huN35V5UDmxaEZc+Tt5DZ6m/la78AWAIyc5HdS49rya3kqnH6rJh+Hy7BcwV9LBvUjnHttRanuFNgIhygXbJ6SHaA8hKbnI7BewJ5Xjs5/M72/s4azgq2Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199015)(83380400001)(38100700002)(31696002)(86362001)(5660300002)(8936002)(66556008)(66476007)(41300700001)(2906002)(66946007)(6506007)(53546011)(2616005)(186003)(6486002)(6512007)(26005)(6916009)(316002)(54906003)(4326008)(8676002)(478600001)(966005)(31686004)(36756003)(45980500001)(43740500002)(43620500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWllOVhGOExza1NWQjZKVXQwLzA4eFlrWExXTlF2V0M1Uk5zWkNuVXd2Qml0?=
 =?utf-8?B?MHUyN3RXMnJDcFlkSVprMXVKWENGQ2o3ZlIrMktpSGlzdzBmZmd6MWxmRExw?=
 =?utf-8?B?QUZSUjZDNlBIWFM1T0JUTkFOdktscUpBRVQ1ajBUd3V5cm5HaWJHenR4MndF?=
 =?utf-8?B?UEI3M1hKUS9kRXF6eXhFSDhCYnRCMm52L3dkZE9JK1pMb0tpa2VSWnN0NzRH?=
 =?utf-8?B?SXNFM09WeUYzT1F2ZFlzMHlCMm52RGt3S096cEU2TGVUcWhERGJUYUhTS3Z2?=
 =?utf-8?B?d1VDTi9oY3ZkTUJ0eU82Z2gxNWVieUlsT0kxTzBkRlFRM3I2Y0lhT01EVVlw?=
 =?utf-8?B?YWJ5ZkRkL25SVnR2MjFyZFFhQnI3UmtMTXFFS1I5cWRGZmN1TzY4Y2ZrK2h0?=
 =?utf-8?B?M0N2OTI1RVovWXNtczl5RWQ0b3BaZjd3Skh3WG03MEFVd2Q2QkIzV002OFdx?=
 =?utf-8?B?a3RMWVZlZThScmk1VXBmSFo0WVkwTFMvQ2lWN2F6RU4yM2FjZUhMdkVaUDlM?=
 =?utf-8?B?V1RxL0VzM1ZNR2tqWmhZY0ptNmdMR1A1UFZHVlJFWXRERWZpQnhUZWF1Vk94?=
 =?utf-8?B?SGpZVUhxeTVxU0dqeGJ4UmFHY2dnWHZTQ09JMWtscitwcU02RTBMV2VqajZW?=
 =?utf-8?B?eFdIZFhGWEQwZHJMdUVQSHFhcXlNY0x4bEhJaFYyMVNmZk40eU1XR3NaT293?=
 =?utf-8?B?REpQQ2FYMXUycitsOXRWcjZvNmRkVlFmdUU4N3dScmU2elN1T0VIc1BJZDhh?=
 =?utf-8?B?Z3FtaXI0cHlITXdtOWtFalorUHBWenZaaUdzSE16U1h1aTl1aHdILzFkc0NI?=
 =?utf-8?B?Z0VyTjBIWVZSTmg1NjFTNDZ6VVpucjlPbTMwL00ydVJzRGRhMkpLM3NleUJv?=
 =?utf-8?B?dWp4OGNDcmtyNlZZL05XVG5IUDBmdjVHK05odFI5bXFnUHJVUk5BRit1U3J6?=
 =?utf-8?B?NGlGN2w5UGdBMWhVU3hPNno0U05Bc0c0bTM2UnZDSzRXZTRjcjNGREQyV2hk?=
 =?utf-8?B?MzgxMjFjZkhpWUx4NkF3MlNkaWdrakswdWtNelFRaHlLRU5wYWsvN0phd1V2?=
 =?utf-8?B?L1d4aXk4SlphT3JUamFoSWxteW4yZGFJMCtmTXZqcmliWmRJZGRUU1lGcXFV?=
 =?utf-8?B?dmRqOXo1ZlVCSEo4b2U2RXBGdWlDeGR1eVEvbmZWenlRMVhvOGlTdXQ3OEJu?=
 =?utf-8?B?N3FIY0dlNWcrYzAzbk5mbVhsMFBnWHlUSCtqNHAzMHdTNUgrZzV5aTVpd1Zq?=
 =?utf-8?B?VGQ2Z3BnRXkwUmpMdzFWZ2RnL0hERGhqTGRWQ2UyaGFNSkNJNFVOR2IzSlRp?=
 =?utf-8?B?SWRYVDBPdk1ueFQzVkNXUnZscDFBbENVQmVVYVY0K3l4ZFBjcDJaS200S3JT?=
 =?utf-8?B?TDNJeXVVeS8vamRXaG8rTlFNOUMzdkpNeEdrZ1dMdzBhbHpmZWZUcnI1eEk4?=
 =?utf-8?B?Q3lxMCtZY2czSkVjd05rdy9QU0VvV1hrWlRMdUlXdnZzNjlnMVgxalBwS1Vy?=
 =?utf-8?B?N0tPblVMMmdZLy9pREFhaXRPZnFPRGZST0hpc294NHFsNFlQRWZSL3hYa2lD?=
 =?utf-8?B?MVhucCs1bGxGQjNDenEyLzNoOENRMnNRY1h4ejhTcmhVS0VmSis2aCsxUFU5?=
 =?utf-8?B?eTBUWHVMSVBPSWJOeFgzMDRYRXJ6QXpyZkNLNC9lNXVEQWg2Q2hER2dCOCs0?=
 =?utf-8?B?TUhSaE9xRHNLcmVSVjhZc1BZR0dOMkU1N2RrSndLV0oyMjE2KysxNWM0c1lJ?=
 =?utf-8?B?UWRYZ3c0QUJkWkhNNi85MEhYei92VXZ4dXNqcHJtOWMzenoza1VOTTNkWnd4?=
 =?utf-8?B?RlhMdXlnUjFEalhVUWg3cldVb3JBSWtLUmFGZ1ZxaWtZYnZOa09TNUV6MTZo?=
 =?utf-8?B?bnF5S0hHc0tiS1dVMmdXeC9wU2dVbVhCUzRoZktDUkZXaldVMkU4a2sxbFdW?=
 =?utf-8?B?clQ5VlBwTHFIVU9XNEhwaGJDQ0hMNTdIbUNMWEVES2NQVlZsVVZWRVRRZUJQ?=
 =?utf-8?B?ZVBFS0lHSTF5YytkbmNzSmxldnBncVkwQW5qdDFlQUNhMjdDR2xLN3VVazAy?=
 =?utf-8?B?eW1ieUFjVGgwUmlpQVVGOXBIc3ZrSTRSL2YxcUNiWGZmN0pEbDMxcS9RR2NL?=
 =?utf-8?Q?zncMRlRF7sQOnj1Djpd/37JJl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba14b15-05bf-4317-01c9-08dab2a3ad81
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 14:02:08.7922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Oce/tI5fojISO/GJWGjom0zpR4gz7Op5OJTEY1cU5OjTcFmg+0ryPAnYEyDeHXaqpIvrDExNNRkmxpRPx+Gzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 16:47, Peter Gonda wrote:
> On Wed, Oct 19, 2022 at 2:58 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> On 10/19/22 15:39, Peter Gonda wrote:
>>> On Wed, Oct 19, 2022 at 1:56 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>> On 10/19/22 14:17, Dionna Amalie Glaze wrote:
>>>>> On Wed, Oct 19, 2022 at 11:44 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>>>> On 10/19/22 12:40, Peter Gonda wrote:
>>>>>>> On Wed, Oct 19, 2022 at 11:03 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>>>>>> On 10/19/22 10:03, Peter Gonda wrote:
>>>>>>>>> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
>>>>>>>>> communicate securely with each other. The IV to this scheme is a
>>>>>>>>> sequence number that both the ASP and the guest track. Currently this
>>>>>>>>> sequence number in a guest request must exactly match the sequence
>>>>>>>>> number tracked by the ASP. This means that if the guest sees an error
>>>>>>>>> from the host during a request it can only retry that exact request or
>>>>>>>>> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
>>>>>>>>> reuse see:
>>>>>>>>> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf

>>> OK so the guest retires with the same request when it gets an
>>> SNP_GUEST_REQ_INVALID_LEN error. It expands its internal buffer to
>>
>> It would just use the pre-allocated snp_dev->certs_data buffer with npages
>> set to the full size of that buffer.
> 
> Actually we allocate that buffer with size SEV_FW_BLOB_MAX_SIZE. Maybe
> we want to just allocate this buffer which we think is sufficient and
> never increase the allocation?
> 
> I see the size of
> https://developer.amd.com/wp-content/resources/ask_ark_milan.cert is
> 3200 bytes. Assuming the VCEK cert is the same size (which it should
> be since this .cert is 2 certificates). 16K seems to leave enough room
> even for some vendor certificates?

I think just using the 16K buffer (4 pages) as it is allocated today is 
ok. If we get a SNP_GUEST_REQ_INVALID_LEN error that is larger than 4 
pages, then we won't ever be able to pull the certs given how the driver 
is coded today. In that case, disabling the VMPCK is in order.

A separate patch could be submitted later to improve this overall aspect 
of the certs buffer if needed.

Thanks,
Tom

> 
>>
>>> hold the certificates. When it finally gets a successful request w/
>>> certs. Do we want to return the attestation bits to userspace, but
>>> leave out the certificate data. Or just error out the ioctl
>>> completely?
>>
>> We need to be able to return the attestation bits that came back with the
>> extra certs. So just error out of the ioctl with the length error and let
>> user-space retry with the recommended number of pages.
> 
> That sounded simpler to me. Will do.
> 
>>
>>>
>>> I can do that in this series.
>>
>> Thanks!
>>
>>>
>>>>
>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> For the rate-limiting patch series [1], the rate-limiting will have to be
>>>>>>>> performed within the kernel, while the mutex is held, and then retry the
>>>>>>>> exact request again. Otherwise, that error will require disabling the
>>>>>>>> VMPCK. Either that, or the hypervisor must provide the rate limiting.
>>>>>>>>
>>>>>>>> Thoughts?
>>>>>>>>
>>>>>>>> [1] https://lore.kernel.org/lkml/20221013160040.2858732-1-dionnaglaze@google.com/
>>>>>>>
>>>>>>> Yes I think if the host rate limits the guest. The guest kernel should
>>>>>>> retry the exact message. Which mutex are you referring too?
>>>>>>
>>>>>> Or the host waits and then submits the request and the guest kernel
>>>>>> doesn't have to do anything. The mutex I'm referring to is the
>>>>>> snp_cmd_mutex that is taken in snp_guest_ioctl().
>>>>>
>>>>> I think that either the host kernel or guest kernel waiting can lead
>>>>> to unacceptable delays.
>>>>> I would recommend that we add a zero argument ioctl to /dev/sev-guest
>>>>> specifically for retrying the last request.
>>>>>
>>>>> We can know what the last request is due to the sev_cmd_mutex serialization.
>>>>> The driver will just keep a scratch buffer for this. Any other request
>>>>> that comes in without resolving the retry will get an -EBUSY error
>>>>> code.
>>>>
>>>> And the first caller will have received an -EAGAIN in order to
>>>> differentiate between the two situations?
>>>>
>>>>>
>>>>> Calling the retry ioctl without a pending command will result in -EINVAL.
>>>>>
>>>>> Let me know what you think.
>>>>
>>>> I think that sounds reasonable, but there are some catches. You will need
>>>> to ensure that the caller that is supposed to retry does actually retry
>>>> and that a caller that does retry is the same caller that was told to retry.
>>>
>>> Whats the issue with the guest driver taking some time?
>>>
>>> This sounds complex because there may be many users of the driver. How
>>> do multiple users coordinate when they need to use the retry ioctl?
>>>
>>>>
>>>> Thanks,
>>>> Tom
>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Tom
>>>>>
>>>>>
>>>>>

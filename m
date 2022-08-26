Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36C75A275E
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbiHZMFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 08:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245597AbiHZMF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 08:05:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2066.outbound.protection.outlook.com [40.107.20.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524DA16586;
        Fri, 26 Aug 2022 05:05:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNy4+ENj37qoUAJp4TlE60l6J3rOfD+pTbSTh53E7VzhgzETYxZ7fkutJXX5XXjgruN6DDVTo39JaFwkq8fiJg0vH0HWQ8osFJvemudvd5Qwt/+P3okL1GcmnzYdMcuiWnNK22ig+vo0emMJWcdMusPoLFaiaFZtXL7bdRKuZgTuBSaAuwxxUIG53k4opB8wCR1fdV1maZCwJEGoTllOG2CLbkAxq1oOkaum9s/bh71R+QlI9eNb83GtRVhJVU5whVgn5R/r9UpLz0n1IX5haQ06iOgNJ4priGjvJM3q1Gp6bLiv+WTjphq7cLUWDu2jsEq52HE2d0KYI24E7Cc1zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuQpR7dO2ESCs49cbDck8GX3cLBzbkHAt1fVqqeKJ8c=;
 b=QRlXCK5UpKLzrLrYADuyRi7xbwXLLTwvJ4bv07BGPnitpm2IAdusDbHeuTDHHAkjeG+s34yq3MAB+q0MBaQwGbrexXh0XUnQGWdJhBsRz9cmidd7+3OpjfEBNCqzueUTZtVd+1O8ixYV7K/rLcYs8AU5qpiVHl2PO8E+TiNfMTxCkEwqTQ95jkpEuvmavFWOFF8CcTKpJxt545b5Sqk9V72dHWLwpepJwSec8XJR2HuDHyJWFNhIPAQozKOSLZdugzV0waTs/TGuphaL/YRX2OBynZEECbs9d0/jFFchRrGccAGP1qfJXXv+61iRCmDBJQSJLqGqNVOHDXhMtkhoDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuQpR7dO2ESCs49cbDck8GX3cLBzbkHAt1fVqqeKJ8c=;
 b=EJqS+mtq+lzfSNfB47gmIEZJx0Eb0k2eBX9zTN/zwTVuhWDSkDUvcNrSmICR60HQMlSIOL0CvTYWNAbOkkh6HDwxc1/v4if3ibfi733VCy7urK3kSbffxU9KgPDrNgz9W6A6aHtpSO+a7oLRYTgiKKYoZxnXeiALsX8XQJ0/64w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com (2603:10a6:803:d::26)
 by VI1PR04MB5455.eurprd04.prod.outlook.com (2603:10a6:803:ce::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 12:05:20 +0000
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::605f:2397:5e51:f896]) by VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::605f:2397:5e51:f896%4]) with mapi id 15.20.5546.021; Fri, 26 Aug 2022
 12:05:20 +0000
Message-ID: <19a61489-907b-2e61-aa2a-1c13d444507a@oss.nxp.com>
Date:   Fri, 26 Aug 2022 15:05:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] vfio/fsl-mc: Fix a typo in a message
Content-Language: en-CA
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org
References: <3d2aa8434393ee8d2aa23a620e59ce1059c9d7ad.1660663440.git.christophe.jaillet@wanadoo.fr>
 <87y1vgocsi.fsf@redhat.com>
 <20220825150127.1fd3a8d4.alex.williamson@redhat.com>
From:   Diana Madalina Craciun <diana.craciun@oss.nxp.com>
In-Reply-To: <20220825150127.1fd3a8d4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P192CA0029.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::34) To VI1PR0402MB3503.eurprd04.prod.outlook.com
 (2603:10a6:803:d::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa14b020-f140-4f15-b8b3-08da875b3f4d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5455:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V3jlBd18gpukoOEapeykUMu1Ql6JuN4ILcn8V81Mp4+aPoA6nD9NUPZZK4vq22O+KORPxZph7wNFzQvTLiqyMR0rn6megPNkm3hG/Z+Xo3aFuOQTtLu5LfcEYD4BOXbKZEXMPp7Mr1wQM/OydYsFql1ejX5FoD6cSwJtT7PQsGLK9xKZHzwo/KDpyH9UYEqihju8L+SAjuzzl8r/Jb929gY1CnEqvK5xasMtwZhHOENR/fnFQzorzLGC1cHdr/FZCKNYOZ1gojtIFErQFLTdOKIK/QZzTumojuZSVMKePPdggIONpq6Rmqt0S3F8mnHw4CDrsUTRL85Va8aTKjkJ3lNGn6MXOTeZSxWslpA970XI3Y8PlvHk1iVC1FyQj4zkK2ViwPhjyrAbP+Iop1hAZ6kyjT0D2e059z2+5xrBTdljxwk+fGzOHzX2FWeGHhNXXl5o5dRNo/6/HSFlOhtNtZOQLk4Rb2fo0UtkEZOGZQCK443EseNswmEzBGN6FJXk/co0bDdOFG048TVcW30rAKlH1t7TkMmm/6Io8LYCaba8RhsEyq7QrwGglSIR91rg/IZEc7ZhGisxnWotCQTVP96T361t+2Mp0kC5rkxjyBl1P4oFyWD8/KCL9yHxApZxyFxB7pDcGZ7rgjGDBO864qHmuy0ZxEFkiv8X6rDCwMz8RRW6xmb4aA4VrZ2vSWU3yx53l3zIKBqYtsA3T1goAeF6eOboeBbjpEvmx9Btn/0thKSehGRRijBQg+91PGuSQI0k4cPHHdnE/j6EbvQzLiAN0VXZq9ZSzvUs0Aib/p3Xua393OcKCN+nS89FxtdfGiTq/gqxYy8jH9yVhXYT1fscD//eqsIPZ2NLx/koK2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3503.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(52116002)(38350700002)(4326008)(6486002)(53546011)(86362001)(66946007)(66476007)(66556008)(5660300002)(26005)(6512007)(38100700002)(478600001)(6506007)(31696002)(8936002)(8676002)(2906002)(966005)(15650500001)(41300700001)(6666004)(2616005)(186003)(31686004)(6916009)(83380400001)(316002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEFPREdwYTFOUDY3Qk80WEg5VFhEeWxGRE15eHBHZkhlZjU3YitRUEovWHhE?=
 =?utf-8?B?T085V2FwT1dGWHk1VjlLRVlKZWNrdjZHYk9GeW44S2w1SFRIMmlPc1l4RFRT?=
 =?utf-8?B?YVlCSFpxT1dJZmI2TUJYcjlpN3ZOOU42RER1VmZXckQ2cFIwRGlwd2FNNzRM?=
 =?utf-8?B?MXhaZDhCY1VsVVB6aEhYQ3NxR1QvUEJQbEpwSGNsa3VxR0hFZ2x6KzZ3bkxW?=
 =?utf-8?B?VjZ6Uk11OFE5b3FhMFZYZ3ZIaW1yUmtOclRBLzFjSVFERVNaRWN3eFEzcjNz?=
 =?utf-8?B?cndKenlScEtSbUYwVDZoczA4KzNDRXByRG1IYk5kb1QxeVhXWjRHeHJ0ekJj?=
 =?utf-8?B?WjE2aE4yQmprZitCMWdtUFdVSjhXUkVFYWh2dGthMzhFVmRxUUZIbDAvTlU0?=
 =?utf-8?B?UkxVb2RncmdVTTJqQ2pWUkM1ZWhVSWs4UjJkN1RVOGFnVzVHWXJ6OW1QVXBu?=
 =?utf-8?B?RWJobCs2cFRCeEJvOFo3Q0RMT1FqTDVNTHM3VzV6djR6TTg0ME9vQjMvQ1Mv?=
 =?utf-8?B?RjdySlJ5YVBuWXZBS3ZlcytCOFI2M3ZUUW9OVnBsT3FmZ2VkcWorcnhUbzE1?=
 =?utf-8?B?NW1FR3dtMGgwRVp4Y2UxbDMrSE5UQUM5d0lBZEN6OWh0Z0N2RGg3NmlGVlNI?=
 =?utf-8?B?R3hURld0QnlPMU9IVGEyUTNLYXVZUEVQQ0lYSDBVS1VVR2JrNFlYdk43Nm5m?=
 =?utf-8?B?TEFjbGExTXV0dGlvNUxOTFIwM1F6dE94dGk4d3UrbTJ6WWhSbjVRci84ZUlJ?=
 =?utf-8?B?YmlGYWhXMUpKaWJ3QlgwU3hhNVFoSWg0TXBVdGs1aFpyMmRudHM2d1NYZ1Ax?=
 =?utf-8?B?bVc4WTlLVDYrSEM2NzQycjZ1RmJIUEluRm9DUXBUS1pTSlp1TE9URHN2Ukgr?=
 =?utf-8?B?c0MxbTZzaEJwVm1WQm1iZ04wTnFVc0FqRE9NeVEzMDdkVEpRTjc5K0VkUm1I?=
 =?utf-8?B?SVBPUkRyRHdudUZEWlRMVllJRjRrWVlMZ1JLZEV3TG80UTJrU1FEOTgrdVNs?=
 =?utf-8?B?VkVnM0pYNWZxUzE1KzF5b24walB2d3NUU1ZFV0RPOFpwdld1cElKMk9iaFhv?=
 =?utf-8?B?a0loUjJId1dIaGRBWm9ITmdlOHVLcVZWOFhlS0dpcFRhMU9nNThJRTZyREpk?=
 =?utf-8?B?RDdEeTlockxjalp3K3VNbllyK3p1UXV4RURBWUV3YlE5dCtpWklGWFRXMUlH?=
 =?utf-8?B?OWtnbC9uMUd4ZTc3SEtXV1liQ0IzNHNzajhxa3NqWEVjQVR4V25Uc0V1a2pS?=
 =?utf-8?B?dVhqTEM5NXBjUm96bk8wSGhkcXh1YXdZU0M0T2VQWmVtaW0vdzAvUzRMQnFV?=
 =?utf-8?B?TkRJclNMV3JkUENHVVNwYml4L0ZLeG5VRnpWSVRmNXJEbS9VYUt5a2RrdkpG?=
 =?utf-8?B?Yno3OHVyeFZJOGl6cjBPbEllNkRXMUlaYUIzSXBWWWpOZHRleGQ5aE1VaXIw?=
 =?utf-8?B?U29jZHVHZXpWMVJRbDdCcmFFQ3FWc1JMK3k3UXhnNVUzZk83TW9qUXlsSVZx?=
 =?utf-8?B?MmM3ZHMyUWt2eVI4UWVncS9QZlgwSEk3VUFXcTQzTE8xR0tnSlFSMDZQdTJR?=
 =?utf-8?B?MVArbFdoZXAvOStUa1F3U2szc0lPdHNFZmZFTlVXc0plR0NyWVAzRzhoMGF6?=
 =?utf-8?B?ZUQwVVpnK2RFNzVyVk5PaFdhWk9zMGp4OWd6cXVVMFdJQTMxVTFLV1JnSXZh?=
 =?utf-8?B?dkt2QXNEZytUQTJ2ZmFmUVpXd1dXS0tOMkJ3ZUpmVVE1aVNnVGlUUk04V1o4?=
 =?utf-8?B?TWtsZWI0K0lVV3Y0eks5Q2s0cVEyK2wzczlGbngyU1hpK293UkdsZWZxZGJj?=
 =?utf-8?B?dlo4anJtZmpuNjI4Y2JVQ0NkMUpWT0hPcndvQTl0bjNDTGJ5bGlTMVdWN0p1?=
 =?utf-8?B?RlhKeWdHa3BVd2YwWEJPTHJlTWRJQ0xwempwWjlMWUR0dXBXM3E5MzRVc3Zk?=
 =?utf-8?B?cDVBZHFmMmZHNlJQMlVVZnB1TzR4WkdIMjU0YmRGUGRIUGlRZENJMDB6NDFy?=
 =?utf-8?B?bHdUYVRMU0M0bHNyNHQ2cG82SEpGWXp4SE1jb09PQWR6U0hsaDgwYlBsT0tu?=
 =?utf-8?B?VjBVVHJzaWdsMVZSNVFiZzFvclY5emkrR0JMWUZyUk45MHc5MzJTdCtDMVhR?=
 =?utf-8?B?YmxkSjdyZzBUZ25uMXpmazM2blJLSStWU2xVK3FPNGpFeEQwSElrVWtScllt?=
 =?utf-8?B?R1E9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa14b020-f140-4f15-b8b3-08da875b3f4d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3503.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 12:05:20.3146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkvsA96aaPBfcqwWkpgZTwlmR6yGxVgDT+tMTavyrsx04FZak2CmNLYVJXskgXHZlk7+rhIU2L65ZR+dJehV0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5455
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/26/2022 12:01 AM, Alex Williamson wrote:
> On Mon, 22 Aug 2022 11:19:57 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Tue, Aug 16 2022, Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:
>>
>>> L and S are swapped in the message.
>>> s/VFIO_FLS_MC/VFIO_FSL_MC/
>>>
>>> Also use WARN instead of WARN_ON+dev_warn because WARN can already print
>>> the message.
>>>
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>> ---
>>> Changes in v2:
>>>    * s/comment/message/ in the subject   [Cornelia Huck <cohuck@redhat.com>]
>>>    * use WARN instead of WARN_ON+dev_warn   [Jason Gunthorpe <jgg@ziepe.ca>]
>>>
>>> v1:
>>>    https://lore.kernel.org/all/2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo.fr/
>>> ---
>>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 4 +---
>>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> index 3feff729f3ce..57774009e0eb 100644
>>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> @@ -108,9 +108,7 @@ static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
>>>   	/* reset the device before cleaning up the interrupts */
>>>   	ret = vfio_fsl_mc_reset_device(vdev);
>>>   
>>> -	if (WARN_ON(ret))
>>> -		dev_warn(&mc_cont->dev,
>>> -			 "VFIO_FLS_MC: reset device has failed (%d)\n", ret);
>>> +	WARN(ret, "VFIO_FSL_MC: reset device has failed (%d)\n", ret);
>> Hm, but this drops the device information, not such a fan... maybe the
>> author can chime in?
> Diana, what do you want to do here?  Thanks,

I would prefer to keep the device information. So, I am OK with 
something like:

if (ret)
     dev_warn(&mc_cont->dev,
          "VFIO_FSL_MC: reset device has failed (%d)\n", ret);

Thanks,
Diana


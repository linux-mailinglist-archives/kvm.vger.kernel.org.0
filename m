Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6614F55E3B8
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345960AbiF1MsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 08:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345948AbiF1MsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 08:48:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6846118B34;
        Tue, 28 Jun 2022 05:48:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SBMBWn024714;
        Tue, 28 Jun 2022 12:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=H42t3keacw652GcwaawyP2fjbd3DCXXYpY1+ZXuHdpc=;
 b=Eo+RvZ9rtKq+e/jiFWLlvBTnis/qvXIzzoHC5K3ig0lGP3wC09326NuvwwiSH7WQP9Du
 ZVANIuV7SmVVecA6i914hnpiFvvjs8pOcpR+nLcESUqJEbGkybpQMHt46/eP1J0pgLJd
 G4FqoTtgqdBb9wZFw2AHE489T3z14wFwHUI45yjURASHa2ENoCG0GlIexq+BuxCILM0t
 vPeSexRcZGWaYhApLRe9JCmz/mkmozOGc27jPWfuzqGuHAtQ6BvnVL/HRm8Q0TO4wbpx
 DDEZu97fnUfdGWs5GA/kwcy8g8AiFNmTB452j9RIQHhq9F4zXCTPcCEKE3VZEOttTboK 9Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwry0e1we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 12:48:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SCfRvt033521;
        Tue, 28 Jun 2022 12:48:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt1u0pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 12:48:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxIbwfu+HYHmbJyYA79ZxRV7QC32KaK0tObJRssHk1MGr7nZ513SK3Rguo2uzVE5tuX9aVAn4RanPOwyLhW/hopNys0ZTKhFYio7kbUzrzb0Lpva1GCLmVpQkVtAPfgTTKoI8qqwVR0TYrhtE+ivAh//FUY7nx7m/UwMGzO03hWfsQvm2vRE/UpIfmJpU/h16wrNruD8aYilm2MG6d+2ML2WQb6J45KvbnP5SJNkxuAbdS3lzMgPvkfzqkF7KoZYx14p/qXGtlI7dKJdu4LS3AV1bV9fpud49GpywnZCtLEeha24FvAKgz8/4EmXI2kg8urmoldzSQc9CtN0hZyjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H42t3keacw652GcwaawyP2fjbd3DCXXYpY1+ZXuHdpc=;
 b=SOnfS7G8bFvn2xCzR/gSj/GLp+EWbiFvY96xQnpUo8L5aVAFU/vf9LjdfmP+gbbOi19hA/WHO9dYMGSoFVwdYJEziRzRS7mOC9OU1KiUj+Y912x9QURZTTfetXvWgH7y5Jo9/ofhftn9vZsEdyxHT/AaNzaCFw4ZK7U64NwqQwHIWPZfgZK/HjVW9AKQhbvjf6kuHsmye/Y7JdUqoiPT1+QCw/Z3iFbi8s/WvhwOhl/STxBQzOuUvS7YR+heVKRXlaZIWvUzIipYvYz6cruKhVvQ7puDbbJd1k82Ep8AcIcMCaAbFjtbNg4/tU9a7bEARFn+5//l2ZN++MsHZo2gCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H42t3keacw652GcwaawyP2fjbd3DCXXYpY1+ZXuHdpc=;
 b=FxvVNa9Wt1GmVZRzSxQOwGkImOwL+eiJxUlDQu9flgfcDtN7SPn/nfl5KHgE/ZyQOr9pC5vFDfH1iBQq4UB6WVSk1vIE1yY2MbxQl3h9qtFV0Rbzyb7W6w+NRPbxLma/oA5swMSdXMHlqTu6VNA4TljkdVh8HTeU6MPEu+Yeolw=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by MN2PR10MB3904.namprd10.prod.outlook.com (2603:10b6:208:1bb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 12:48:13 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::dc4d:56f4:a55b:4e9]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::dc4d:56f4:a55b:4e9%6]) with mapi id 15.20.5395.014; Tue, 28 Jun 2022
 12:48:13 +0000
Message-ID: <7217566f-9c40-ae9d-6fd6-2ef93f13f853@oracle.com>
Date:   Tue, 28 Jun 2022 08:48:11 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] vfio: remove useless judgement
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     lizhe.67@bytedance.com, cohuck@redhat.com, jgg@ziepe.ca,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com
References: <20220627035109.73745-1-lizhe.67@bytedance.com>
 <20220627160640.7edca0dd.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220627160640.7edca0dd.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0072.namprd17.prod.outlook.com
 (2603:10b6:a03:167::49) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68e64b07-7481-4472-aa2c-08da59047686
X-MS-TrafficTypeDiagnostic: MN2PR10MB3904:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/uIH+RVsBLxb4m8v94To9ZRUUe588uYzpVUlHrdwtlXKwnBeMf6X0FsT4drGNBkl3YjHHq/wJwdZLHWIweu7x9jaqmIaI2DRCaZRsdQRIpGwmVrhQwSldWUkzVzfX5cQsZJq6du/D3LX0hnreOrGgc87XUkicq65RwWyfmdwIA33zld9rKc9wZuk0PPm7nbYYj7mwTctb00Ar1JyLwlDQY1OlLxqiRqmw2FORkhyna8NcR7z48p/hbjaDJDX3jg5GQEudXeo8ivWX3AzOAHieEpOX7/DB41qmeXQux9PUgRjb39eudVe2W0+gIHfky1PVzEr+7uhUNjvTvLdszAvMRAxFc6M2u0nUBaVYs66yjGBcSXDy6S1D7OXaCeg8ts9a06lFE3hWnbX3Xepps+Wdb++vBHsc2nfO5X43j5uIlW71ZIs/4a3UmosIYRhqP9Fdz9FogxX/V13TxZskSVl/HcckZul39vGpHxvCTPBQXu40nAtO3B4MNCHMw8xQNaizsfkGFo95Z/5PkYGInCSKyW2lL9pdXlE8ovaLRZpo6cruQJY3eXYpJaPVMFPpo4/H1LebsfS5NERgDPcFoji1q4V6iLnQ+PpNw1sSJBtJpNGFPkdgPW0Q7UQbrX0ZM5stTxujRaEp+HmlB1RBa6Uh5sivemvTe5fw1dFaQfQmB415Acw6Dnsx9lty0IkE/BbpFoNYIqmZTaLtmaNY4r2eydqf2pBOdbhmn25XQRKZZtEY0uFKYIy8df969CoKhNQX5lvVpXbMpWjVjjLWldiFTcKNG+bEQ9p+5c/nM2SS5MOxMnBRMJ+8/SmKbPz1u/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(376002)(39860400002)(396003)(346002)(66556008)(6916009)(316002)(36756003)(31696002)(66476007)(31686004)(66946007)(8676002)(4326008)(83380400001)(2616005)(26005)(186003)(6506007)(86362001)(36916002)(2906002)(41300700001)(38100700002)(478600001)(6486002)(53546011)(44832011)(8936002)(5660300002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVZEa2JIOEVybE9mdFloOTJrY1RiNmlZdlAwVjhiNVNMdnQ4N0M2QXgzQWdQ?=
 =?utf-8?B?ckFMZGRXVlc2T2VHUFFTR1ZYQU1SeTZZbGpQZWZMT0VKbklUSTQrM25xekV3?=
 =?utf-8?B?amtCeXRzSGZmL09RbnBZNWE2dnF4UkdXRlgrVnYyOUNEb0N4NXZYU0haOGw4?=
 =?utf-8?B?T0g2N3R0b2dVaVFLaTV1K0ZabVNOSk15UERGU0pydWJjak9FWWMyWnh1SWFo?=
 =?utf-8?B?c1VVRW50M2NjWW91eFFQMmVmZ01HVDVJL3dEaFY0R29UdFFyOVRXUEVIT0FH?=
 =?utf-8?B?MFVRUFcyUnpJa3pFNS9SN2NtSmFncGQ1NEdZcVhrT05weUphRUpzUWVkbjFH?=
 =?utf-8?B?VmQxOEt6UGRMaFFJSW9yNTdpVmQzUVRJVSsweUtkU0pSYloyWjRDVWpISE0z?=
 =?utf-8?B?cTVYdVdzTjhTREs3c0dBYzFGSVZ1NVFqVG82djFwRzEwYitUQ29pRmlwSmh3?=
 =?utf-8?B?VzNTa0NSL3pLWkMvZk9SS3JLUnZHRmJHT2lqVUFQb0t0Y1MrZGRwbWFWdEY5?=
 =?utf-8?B?VSs3NXhWRUtXNFE1K0l0cVZDdmg1OWNRRjZxVzZEL3JKVWNmZ2liTzFLUlNx?=
 =?utf-8?B?NVV6OXdtWGZaa2YxZ3UrdE1oUjFqWDJYcXNYWnVBNTVvQjNwUm03czVHTVNi?=
 =?utf-8?B?TE9ROUNvNzNOT0xnZUFNQTNxZ0FTdHZ0UDdLZzV2MVBJYVZiQk1ad1pyM3ZG?=
 =?utf-8?B?YTFFTDErSXFrbUg4dFFqMENBZXF0M0hFQUx0LzFXOStlbzdXV0RNenpsRkxT?=
 =?utf-8?B?Y0V1RThZK0hrcnJtWXVkRjFJdW5jK1pUVnhjWWZmV0RiaUJGVUZjVmx0T3Y3?=
 =?utf-8?B?Q2ZaMFJJd250UlN0dE9hQ25oZVc3VTN2Qktwc2N5TExOZTVLaUJqN0dQV0FS?=
 =?utf-8?B?K3BTbHVTVmNsS2tZa1hGdXUxTlQ0RDBia0tYend3K0h3c1FjOTR0SGVuSDBF?=
 =?utf-8?B?TW8wZThObWU3SDZZMisvVzhaeVNNTXpYMitaZGVCZjNJbmRsRFhTUmtnU0hr?=
 =?utf-8?B?N2hzY2VVVGxOSFRiL3NjL0ZYNWpYN2lsZ1JmM0NhYUhuQ2ZLZkZtSlNsYU5B?=
 =?utf-8?B?YlFqTEZLYkRjbzhOT05nczZVTC9YSzEzMDQ3djFQbm5CdTE2cnUrdU10MUxB?=
 =?utf-8?B?V3Ezb0xrMWMxQzNaZ0ViNzBCQksyUk9qQy9xb3BxTjhicnZMa1Q1dDVGMFpD?=
 =?utf-8?B?L1B0MkRrWitBMWJVby9JWm9Td0JqS0VSaUhMNHlhMWJFdmZZZGxRbDBuMUJt?=
 =?utf-8?B?TVpmaFdiU0RDMzM5UTBwdE9XbFFiL1NxRG56YXJTcHZGMUt3NTRzeWF1ank3?=
 =?utf-8?B?UTN3cG5VbjZZN0RYY0NxU0JKMUhtenBiRHp4VlFJOFNCK3lPZnVTTGRYSlB3?=
 =?utf-8?B?MjY1V3ZUUUhvb2FTTnB5Z1pvZ0hjaEhnQVh5T280VlRod0xDRjBQTUpOdnBJ?=
 =?utf-8?B?ZW9KQ1VYUzhzRGxqc1lGTE9QcWxsckZaU1duVHBFdUovcmZMRlovUkNCZmJ4?=
 =?utf-8?B?OTd4QnpkVUhHUk1JTUtSRjVIQjkvbTVZY3M1N1B1ay9ObGdlaEZHRk5Hci9W?=
 =?utf-8?B?MFR0NXpiK3h2S2hQTXRUM1lYRFdQY3RCYWQ4K3hKRXN2eDdRc0tjV0xYK2JX?=
 =?utf-8?B?bWVaV1Z5L1RXU0lIQkVvZHZ0cXhXRWdFWWhkVW5mWWNKOHJOZW5uS2o2cEhS?=
 =?utf-8?B?SUdnUUo2Z1NhTGU1R09FTnpLK3FuWkE5M3h3UmxDcUhYcWhwSHEzMS9ydldh?=
 =?utf-8?B?UlZnOFVEZ0J1eVN1ZWZRTDNDNXlwR1lBbllwSmErVUNFYkpwMjVPM0luU29q?=
 =?utf-8?B?cHRRbVN1WFFrcWEzR3NId0tHbEszSlRaSjV1NG42WW1xTnNjelJlRVVkR3JD?=
 =?utf-8?B?cWI0OTJwUjQ5SlFIdHlRSlBvSCtlOGNJY01sbmwvaHVJOTVTNkVsakdGcUhF?=
 =?utf-8?B?c2dOUGdrRS9zdk05NXlJNzdoYjc0MytWNncwbkJEYThEUGtHalFVeStneGFM?=
 =?utf-8?B?SkVwK2dkem55NTFtblJwZ1NDZ0lNZWtFWUpQeGozSzZ5SkdZMVlLbUpSSGRj?=
 =?utf-8?B?N1cvL3pIaVo2NFVYOWxDWEg3bnhHYVdXSWtBWWNodHcvVzAxWVBxUEMvQ2JJ?=
 =?utf-8?B?TDNjb0ZWZFQ4QlJkV2R1YVBvQWFFY2VMQXlZcURzRzVKLzA0bWYxZDh6K3Ni?=
 =?utf-8?B?N0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e64b07-7481-4472-aa2c-08da59047686
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 12:48:13.0874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: psBKxnXwrwv1Z16KUlsgTYgHfzcb9TZ9i7o9utYwSbCMXoUoPVda2mAwajg1lW4DP5zJD2oAcUO+dewgLOLmTTdKZg17bmMHVUysGC6xKDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3904
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_07:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280053
X-Proofpoint-GUID: 6TsPf8Vv3XYj6x-0rIqVMAWJjVwJi-7z
X-Proofpoint-ORIG-GUID: 6TsPf8Vv3XYj6x-0rIqVMAWJjVwJi-7z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For cpr, old qemu directly exec's new qemu, so task does not change.

To support fork+exec, the ownership test needs to be deleted or modified.

Pinned page accounting is another issue, as the parent counts pins in its
mm->locked_vm.  If the child unmaps, it cannot simply decrement its own
mm->locked_vm counter.  As you and I have discussed, the count is also 
wrong in the direct exec model, because exec clears mm->locked_vm.  I am 
thinking vfio could count pins in struct user locked_vm to handle both 
models.  The user struct and its count would persist across direct exec,
and be shared by parent and child for fork+exec.  However, that does change
the RLIMIT_MEMLOCK value that applications must set, because the limit must
accommodate vfio plus other sub-systems that count in user->locked_vm, which
includes io_uring, skbuff, xdp, and perf.  Plus, the limit must accommodate all
processes of that user, not just a single process.

Folks like fork+exec because it allows recovery if the new qemu process fails to
initialize. One can fall back to the original process, if the above issues are fixed.

- Steve

On 6/27/2022 6:06 PM, Alex Williamson wrote:
> 
> Hey Steve, how did you get around this for cpr or is this a gap?
> Thanks,
> 
> Alex
> 
> On Mon, 27 Jun 2022 11:51:09 +0800
> lizhe.67@bytedance.com wrote:
> 
>> From: Li Zhe <lizhe.67@bytedance.com>
>>
>> In function vfio_dma_do_unmap(), we currently prevent process to unmap
>> vfio dma region whose mm_struct is different from the vfio_dma->task.
>> In our virtual machine scenario which is using kvm and qemu, this
>> judgement stops us from liveupgrading our qemu, which uses fork() &&
>> exec() to load the new binary but the new process cannot do the
>> VFIO_IOMMU_UNMAP_DMA action during vm exit because of this judgement.
>>
>> This judgement is added in commit 8f0d5bb95f76 ("vfio iommu type1: Add
>> task structure to vfio_dma") for the security reason. But it seems that
>> no other task who has no family relationship with old and new process
>> can get the same vfio_dma struct here for the reason of resource
>> isolation. So this patch delete it.
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> Reviewed-by: Jason Gunthorpe <jgg@ziepe.ca>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index c13b9290e357..a8ff00dad834 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1377,12 +1377,6 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  
>>  		if (!iommu->v2 && iova > dma->iova)
>>  			break;
>> -		/*
>> -		 * Task with same address space who mapped this iova range is
>> -		 * allowed to unmap the iova range.
>> -		 */
>> -		if (dma->task->mm != current->mm)
>> -			break;
>>  
>>  		if (invalidate_vaddr) {
>>  			if (dma->vaddr_invalid) {
> 

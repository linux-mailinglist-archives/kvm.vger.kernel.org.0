Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2091C75DA95
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 09:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjGVHRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 03:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjGVHRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 03:17:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60B03C01;
        Sat, 22 Jul 2023 00:17:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OawMx5wdr1J6B7Jf8hDasnEt5Ppvw4VhNvgouwXuBD8sDcUO9JtGG7BsQz5XlR9NH0EZ/WnHVJB1rBLLazFRyJFQn+ClFgboSTgg2GuMagFSRGepEn38PT5ayml0371qdMPvI6uch1wvoX+8vLlSZB8DWCuEHcdRSu1Z283FenIC2AmEPDPctRl5+KOXO3udKQnsMA1SmHF0ZyJxJlZwTb6WP3G/asgk2DC4zB/oayJstV0MxQ3vmMfPHk0EtFylu1pp8Pg6fnT0AxSFYfPnB/Hwi/8T9cU6/VeugRzCJOAe2oTnJql/GShrcPLV6+w8Ceay5s5U8Vyfzz+G6uPIxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6d/nDKUczsxCE46JzS2JY4QmqUp6o79U1ItvpNpxv0=;
 b=hgaoOtcWI05qtDSOd6p4OsgJwHDle/QpiG4f5mkeLkpZGiPw31Pxgi3AWNubgkK4IZYLe7YtBFFYubuzJaGFusXw6L/6R989rskq5tl0IzkMdWCiphA3c+1oKFuoH13W/ZqWZG1OKBQNMh9VNkiYull/AHlWCSyzskTy6D4752Y0mKDGT0HVrhGJbT8HTdAyWTcRo5L5U3dHxuQHI5/FVgr1WKrBJ8e48QeX+1hqt0EmsjHysjcAWa6K//MC2P31He7a0uq8+aIGNS0TzozLIVAc43ptcVJS5L/9UrgaRtApIguwMOy/JDcT1bt5aTxSUPFJyL6p03PId5WemrWN7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6d/nDKUczsxCE46JzS2JY4QmqUp6o79U1ItvpNpxv0=;
 b=wPM0BQLGCkfrtCyEgx/8CicWPFgktE33GIb8M6N4civ9GFbYNy7mqnvNxdZSQuM9QIWCzWGlMmZsfhs8SC6vI46xA+NmN44e4at+kJqXhkhxMSuQVIEkVdC7p+gdusr5a2cXR+oNJDZYPuDRAVcMfNSFEAEvdjtUO9iM4CQyR5E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH7PR12MB7354.namprd12.prod.outlook.com (2603:10b6:510:20d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Sat, 22 Jul
 2023 07:17:38 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Sat, 22 Jul 2023
 07:17:38 +0000
Message-ID: <259c5f0d-24bf-dfd4-a1c5-102944aecd4f@amd.com>
Date:   Sat, 22 Jul 2023 00:17:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Cc:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-5-brett.creeley@amd.com>
 <BN9PR11MB52761AA921E8A3A831DD4A1A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB52761AA921E8A3A831DD4A1A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:303:8f::31) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH7PR12MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: ce005855-5373-4ca5-56d9-08db8a83ba86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+njimFrlFhaZSm0domTUJ/l63glEDySKHpCyoFuaTZ1dzeMOhCrvO3F7fMB/V2fP1jkU0jIQWDkquv/uxgBcBnMSRKtWWlEshYmeuTiWnZKesbPBc8Sb5Qj53QUMUlp/XQ4322yrRoWtO4RC0B7W7i8mZqYcbDo5Jr+VV80MpQI54NFVw100d7IyW0+V71PvoQwU/VZEVOmAZLu1offCNalryKvokY5e93TVzf6ByzHhxGIpFd/PEI+tv+OMfmitU6xnhUHP5JvFjEifmoDo8dxQUBNQF5Kc7OH2kypl4HWVerWbBpQWq3L9LGSJJn4VGM2zYcF2CG/0uluMvE48cfhoe3A1QSDX96ESKRl6Je+zfa7DbrOy3IR10N7lbYwhPgly+EcPRiA8bx2FD3SgfRkYEFWmfUIECsp3RBDYOPfLs10DRB1tOWlsujK/bT1pkXzsbEzqL9Z2gz1L3U1LGoyoWFXMYPenOsloknpkup0KyNiqMnSrb/lpV2YY00ygzsou7+NLRAzH+RIE+iU/EouqtJstBHvW9xElQUo8gH9UJKJ+/dw7gbVHltF51Bdudr3RKlXc2GepfMXSvlmnpV1GURgTqX2Ibdgejl+9NwxtlK2zYua25qjjJBESkfBlTNjwDjNYqf7dfM9+CUQPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(316002)(4326008)(66946007)(66476007)(66556008)(38100700002)(6486002)(6512007)(6666004)(31696002)(110136005)(2906002)(478600001)(36756003)(41300700001)(2616005)(31686004)(5660300002)(8936002)(8676002)(186003)(6506007)(83380400001)(26005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG0wV1BHZDFKNXUzeEdOVGxmdkQyenFHTEJyaEhORWlwODVVSDVPaFZHM3N4?=
 =?utf-8?B?QzF0bHM0UklLUXdnbUdNYm56NFdlT205UlhscGdUVWJjZzZvc1JLRktseXJz?=
 =?utf-8?B?YmVxSW05NWFRL1Y5dE9xbVVjR0ZOeldyQ0dYQW1zRHFyS2xDNFp5TnJMd0dL?=
 =?utf-8?B?c3pPQXVTbjRHUWJnVVBCTDVJMXBCNmsvT0JTMDM5Mk1qNDQ3YmhiZkc3dks0?=
 =?utf-8?B?MitFK1poTW1iWWw0dG16YXJmcE9GTWszTUFRYXpZb1RxZVpycEN3WVl0OFB0?=
 =?utf-8?B?ZENoQ0x0L2xXQnlvMzhyME5TaW02WmxkSlIyeWs2MzRISlZQb1g3ZFp6eDN3?=
 =?utf-8?B?c21EWTVvRkpRL29nSXovRExLTmhHbmFPdThhZHk3SkRSTXU0L1RISXRObjlq?=
 =?utf-8?B?SkRwMXpDTy9PZmZZeUJsUk1jdW5mV3RZS0NlN0pSN0lFVnZId1krc2lnMFdQ?=
 =?utf-8?B?NWgrd3hscjNVa1BCTE01dGM4VnFHVU9tUkgvYUpoWFBVRWVTZFJ1SVMvYlZp?=
 =?utf-8?B?V1pkVk9zMWllcGsrdTllbi94Q29PS0hMWHRoL2NXeEZlblZNaUdNaDNVdW9s?=
 =?utf-8?B?cnZMd1U4c2pTeEpGSkZlaG82U3NyYU9ZOHlQa0diQWZ4T1lTTXRQZXNQZ0VL?=
 =?utf-8?B?M3FaSkV0ZUdoZWltZUlsY1hCbnc2REFUSElCY1FxTmNTWklXeUcvMUNEZks2?=
 =?utf-8?B?akRGVUVNOC9IeUFydHRzc2E2OWZLQXprb1dEamtYdzVmUHZlcGNqUVRqRVox?=
 =?utf-8?B?dm00alE2d3FhUFdXb29jajZqYm55MHZ0VUdZdHRqWVZ0L2tJNzNiRzFJZzY4?=
 =?utf-8?B?YTg5RThNelVWSkszS0Fhck1nbmxpMTlBTk9KU0FNcE9BSVFqMlpwUldGWER0?=
 =?utf-8?B?b1l6TCtKcnhyMzR2dXF5SXduZzRWdjAzTWkvT0NZcEYwS3QyYnNxaHFySXUv?=
 =?utf-8?B?cEptRlJ0YzJGUElBeld0QVBpSDY0TVRNaTJpckI1eWwvdEY0Z3cyWHpmSXRr?=
 =?utf-8?B?elpoUjcxQS8zN21lMzcxbkZaSm95Q0ljMnBTa3NRRTFtQTdZTE9PZmJsRHJM?=
 =?utf-8?B?WTIxbzFuYzNNelVSTVVIMkQxeFFhUHVSUXFuYjdPVG5qS090ZDVxVGw5eVZI?=
 =?utf-8?B?K3ZzUG9taUpKQzdmYkhTVXZsM29CZ2J0ODd1YjQ4OWZuYXhOWjQ3bzRYSnlE?=
 =?utf-8?B?VjRJWU13VEhsOFhITEVWYUJlR2wxWXY1SFlhVFJPTldzS2pQZXhvaVBpQ0Y5?=
 =?utf-8?B?NGx6REthRi9hVWZhY1RFNG1TcHlUV2twOGRzUElkczQzTkk4ZWxGWjAwenVp?=
 =?utf-8?B?WVI3NWVGN1FRYjNVbXNjUjFDYlh6WmRPVFNtdW9sc3E3eE5JZHg2cHc5dkZr?=
 =?utf-8?B?SG5NR0luVEFBbjJWMzQwWldPNWFDaVViaFNwQkNudjZoQ3ZyNG5RdThNK1JY?=
 =?utf-8?B?UENVamxoSlJHdlQwRmVOSkY0OVJ2VmtDSjZQY1d5eHR0U1VqcXp1aXN0WE15?=
 =?utf-8?B?L2FxMmpiMGVYdkNNVy9COEJDdW9wRm5jWUpoSzltNVpvdFI0SVJSN3BueW50?=
 =?utf-8?B?M0o3QVJlMGhVa0Z3RlRGaFhvUTRwZnBwaG10YjI2TkdrZkhxa3Z1bVM5UlBw?=
 =?utf-8?B?ZmluNGQ3NWZGMGRjRitvd1AzZlJCRGZRMnNBZVdWSFIzdzFMN1hnU2doTjM1?=
 =?utf-8?B?dU85MWp5Tmo5TTVycjArZ2hSNDZSYk9IbFBNMTRDb1hCdkZKMWRReGZXdzdG?=
 =?utf-8?B?dmhid1VSZ1YrdDg5OU1rcmZpZHp4VTN2WmJ5bzBReHdkUTJrbGEyTXVCcGxB?=
 =?utf-8?B?dlhRVFUrSE1NYUNKcFIwMEZoL3d6UzFMMkwyR1BXKyszbWhsbE8ranVMbjFw?=
 =?utf-8?B?M3FkOC9KWFlVVlV0NkNsckFYWTdoVFhGZ0NnVkFkajFPd0F3S3BERHZ5UVdv?=
 =?utf-8?B?cTRocWR1QWI4U2xRTURmaDkxOXRuQ0xsSXllSzYyM1V0M25YaHdwU3NvNm5o?=
 =?utf-8?B?YkJlQk9FT3Y4UTI4WVdrYjY1c0YzRjdwVWdPN0ZRbnFsd2VvYTZueEpUR2cw?=
 =?utf-8?B?V3ROcXY1M0w2aGtkbmFtVTJHc0UwNXhGY0VVanZpN1BoQWZmWk1JWlB0Rzd4?=
 =?utf-8?Q?742Ks8T52M/XECcSESF8cv63i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce005855-5373-4ca5-56d9-08db8a83ba86
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2023 07:17:37.9113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kGpwt5poCBk6YHpcw/PnfL+WhKtDpVKou5IGB5zqdJEEbVq6VHEL192zzEq962HXrCbPciqASOg8UmSKWn04Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7354
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/2023 2:15 AM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Thursday, July 20, 2023 6:35 AM
>>
>> PDS_LM_CMD_STATUS is added to determine the exact size of the VF
>> device state data.
> 
> based on the description PDS_LM_CMD_STATE_SIZE is clearer.

I will take another look at this and see what makes the most sense.

> 
>> --- a/drivers/vfio/pci/pds/Makefile
>> +++ b/drivers/vfio/pci/pds/Makefile
>> @@ -5,5 +5,6 @@ obj-$(CONFIG_PDS_VFIO_PCI) += pds-vfio-pci.o
>>
>>   pds-vfio-pci-y := \
>>        cmds.o          \
>> +     lm.o            \
> 
> nit. "migration.o" is more readable.

I'd prefer to just leave it lm.o as I don't see a big benefit changing 
it to migration.o.

> 
>> +static int pds_vfio_client_adminq_cmd(struct pds_vfio_pci_device *pds_vfio,
>> +                                   union pds_core_adminq_cmd *req,
>> +                                   union pds_core_adminq_comp *resp,
>> +                                   bool fast_poll)
>> +{
>> +     union pds_core_adminq_cmd cmd = {};
>> +     int err;
>> +
>> +     /* Wrap the client request */
>> +     cmd.client_request.opcode = PDS_AQ_CMD_CLIENT_CMD;
>> +     cmd.client_request.client_id = cpu_to_le16(pds_vfio->client_id);
>> +     memcpy(cmd.client_request.client_cmd, req,
>> +            sizeof(cmd.client_request.client_cmd));
>> +
>> +     err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, resp, fast_poll);
>> +     if (err && err != -EAGAIN)
>> +             dev_info(pds_vfio_to_dev(pds_vfio),
>> +                      "client admin cmd failed: %pe\n", ERR_PTR(err));
> 
> dev_err()
> 
>> +void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device
>> *pds_vfio,
>> +                                      enum pds_lm_host_vf_status
>> vf_status)
>> +{
>> +     union pds_core_adminq_cmd cmd = {
>> +             .lm_host_vf_status = {
>> +                     .opcode = PDS_LM_CMD_HOST_VF_STATUS,
>> +                     .vf_id = cpu_to_le16(pds_vfio->vf_id),
>> +                     .status = vf_status,
>> +             },
>> +     };
>> +     struct device *dev = pds_vfio_to_dev(pds_vfio);
>> +     union pds_core_adminq_comp comp = {};
>> +     int err;
>> +
>> +     dev_dbg(dev, "vf%u: Set host VF LM status: %u", pds_vfio->vf_id,
>> +             vf_status);
>> +     if (vf_status != PDS_LM_STA_IN_PROGRESS &&
>> +         vf_status != PDS_LM_STA_NONE) {
>> +             dev_warn(dev, "Invalid host VF migration status, %d\n",
>> +                      vf_status);
>> +             return;
>> +     }
> 
> WARN_ON() as it's a driver bug if passing in unsupported status code.

IMO dev_warn() is good enough here. I don't plan on changing this.

> 
>> +
>> +static struct pds_vfio_lm_file *
>> +pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
>> +{
>> +     struct pds_vfio_lm_file *lm_file = NULL;
>> +     unsigned long long npages;
>> +     struct page **pages;
>> +     void *page_mem;
>> +     const void *p;
>> +
>> +     if (!size)
>> +             return NULL;
>> +
>> +     /* Alloc file structure */
>> +     lm_file = kzalloc(sizeof(*lm_file), GFP_KERNEL);
>> +     if (!lm_file)
>> +             return NULL;
>> +
>> +     /* Create file */
>> +     lm_file->filep =
>> +             anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
>> +     if (!lm_file->filep)
>> +             goto out_free_file;
>> +
>> +     stream_open(lm_file->filep->f_inode, lm_file->filep);
>> +     mutex_init(&lm_file->lock);
>> +
>> +     /* prevent file from being released before we are done with it */
>> +     get_file(lm_file->filep);
>> +
>> +     /* Allocate memory for file pages */
>> +     npages = DIV_ROUND_UP_ULL(size, PAGE_SIZE);
>> +     pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
>> +     if (!pages)
>> +             goto out_put_file;
>> +
>> +     page_mem = kvzalloc(ALIGN(size, PAGE_SIZE), GFP_KERNEL);
>> +     if (!page_mem)
>> +             goto out_free_pages_array;
>> +
>> +     p = page_mem - offset_in_page(page_mem);
>> +     for (unsigned long long i = 0; i < npages; i++) {
>> +             if (is_vmalloc_addr(p))
>> +                     pages[i] = vmalloc_to_page(p);
>> +             else
>> +                     pages[i] = kmap_to_page((void *)p);
>> +             if (!pages[i])
>> +                     goto out_free_page_mem;
>> +
>> +             p += PAGE_SIZE;
>> +     }
>> +
>> +     /* Create scatterlist of file pages to use for DMA mapping later */
>> +     if (sg_alloc_table_from_pages(&lm_file->sg_table, pages, npages, 0,
>> +                                   size, GFP_KERNEL))
>> +             goto out_free_page_mem;
>> +
>> +     lm_file->size = size;
>> +     lm_file->pages = pages;
>> +     lm_file->npages = npages;
>> +     lm_file->page_mem = page_mem;
>> +     lm_file->alloc_size = npages * PAGE_SIZE;
>> +
>> +     return lm_file;
>> +
>> +out_free_page_mem:
>> +     kvfree(page_mem);
>> +out_free_pages_array:
>> +     kfree(pages);
>> +out_put_file:
>> +     fput(lm_file->filep);
>> +     mutex_destroy(&lm_file->lock);
>> +out_free_file:
>> +     kfree(lm_file);
>> +
>> +     return NULL;
>> +}
> 
> I wonder whether the logic about migration file can be generalized.
> It's not very maintainable to have every migration driver implementing
> their own code for similar functions.
> 
> Did I overlook any device specific setup required here?

There isn't device specific setup, but the other drivers were different 
enough that it wasn't a straight forward task. I think it might be 
possible to refactor the drivers to some common functionality here, but 
IMO this seems like a task that can be further explored once this series 
is merged.

Thanks for the review.

Brett

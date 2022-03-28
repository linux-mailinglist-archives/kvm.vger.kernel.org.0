Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F984E9978
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 16:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243810AbiC1O3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 10:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiC1O3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 10:29:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496E45DE64
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 07:27:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKpAP/Y9Elr45lcockaRWQ1rrbtuNGuqZoYmQxU2PFlbyEbiwoT6sJ2FM7rog9xBscG+7dhZQfE7SyJL3Gk1pypnnSrlljYJgGTUgZRhLdSWkVdItawBYPNozqks4SeMVlvDVqZgmdsGPVx3XPe8riWm/6/1TLO1HCTQD5+wCI1n+xJMBzCJnhrlk9siAL9c3E7CHZmfHLH8DLSZDnSALoyj9Z09+Pyi1MHeEIz8YolbxOQQk3A6mDLJ7bHPcdGIvbTgjHGsMwPKInNcxBa/1wfLK6mzkYb/4ksrG1Keq/PxwWYbj3+6GOj/kINai8gHYE5DvJN1cxiQ9E1KQEDbbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCqcNI7Gsn8EueQsIgCp0TvGpSQmPdJNlHppZuDqTz8=;
 b=LAm1OO6N7SKNtj4W2RKgBpm9FULEQ1t74IyEXofk0cVg91x8KTPgnLYnNEdoML+ydOJfoR+DBrMpehuDsNdbMicCPvOiX0TXQzpWjdV0r/ZMUarwvBaU6ZuJqCZjL/C/d/Pt2aLCCP5S0qPX4cK7nejIs0d5sqwKuLX96Vw4LrvCtQd0up55YWD4fm31VnwOi+j0s3W6+9cVArshJZRs23wdwd2z7ao0a4JbX+OZLE4+N5Xst3x5UyvFkki6cHxzg0jtwhHrhu02JP7cFFSrQP2pd2yrPVfu8cEQCuJwNIRthRcsjDlTKJv3tGyFDzCS90vrhjBIiBGtW/gqYTy0tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCqcNI7Gsn8EueQsIgCp0TvGpSQmPdJNlHppZuDqTz8=;
 b=hPKrt6v/H1pqtIMo0FvWyaLLw1FzVvu61E1zJtgWmI2M3VeRhlEtB6ftpbeLrh03eJqL9je3gYaUiuhtZ3FRlpb7urcoNlFKvgdRz9MwnRmsDqt4bKi8nMOtQ6SahY8iG0njFed/fEMJcSCLY1KZNHsrur1wQBJc4awF4ibg7muydA47YKfGzyPEteLbI5HcqKSjOHhE9SGEaY3VoVGKgOIWa6XteaAWqWyl9wzUgji/OGj4iFyUKfvKUWsERCheg9vDyW7zvbIj0oJs7Tq5TLulvZ6Zs2qJuUyO8bI57tPfC889MkMU/Qd/O7wgavae+GqgiddpNP9ohX/pqXrrIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5317.namprd12.prod.outlook.com (2603:10b6:208:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 14:27:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 14:27:31 +0000
Date:   Mon, 28 Mar 2022 11:27:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sean Mooney <smooney@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220328142729.GQ1342626@nvidia.com>
References: <20220322161521.GJ11336@nvidia.com>
 <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
 <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
 <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
 <20220324114605.GX11336@nvidia.com>
 <CACGkMEtTVMuc-JebEbTrb3vRUVaNJ28FV_VyFRdRquVQN9VeQA@mail.gmail.com>
 <5accdd9074f20e8fef30984285a23366b7025497.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5accdd9074f20e8fef30984285a23366b7025497.camel@redhat.com>
X-ClientProxiedBy: MN2PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3b903fc-d9b8-481c-814c-08da10c717af
X-MS-TrafficTypeDiagnostic: BL1PR12MB5317:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5317A3C7768FCEE62B22B8B3C21D9@BL1PR12MB5317.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQJ/v7aS1wIE+B7jE/8TKhGnId7ygWaWxVS1yFw+lA6xoo/Yl9BHyTGvkJq2Q62PY8OLJTFrITrUdSKVIdS+ZY6iI6kWy/o+Cb5HCP2mJEP3vvN0giA+XA16hvxPb7Zy9eaVV8S9tVDgRzn+SySOd1pKRCldKOnrNtkq6sbtHFdjubhVfjDIMTOKZWZ+e7Zo8/ZtiXbcaJvGV22ZBrlCIySG7DPbNuyFWDAyjMKDvzuxA02RbQoVZiGU9z+tz0CK/glSEzNfUOZaOhhj6uAh10IYc3S5yDv/w5+5xHYWGSiPau1VXIFoT83hlf3Ivzyp3KontODrjOibqZmkOIbr585X5XteK/P4xfRp3uPOaA2LnBQ73br65d+4dv/hkg77kQyWljIytUV+a4Sgapl+dB2CC+5kRzVIFwwlQnXeeyK7WHjTkxNAh+8EvSrm3hpgrVNoro58eukmohIRFJEM5WXiWM8LJZkl88cdCaEHkpxriNb7qcGQGdyUVylWix/7Yly48+L5DVr6WXSIGGba/NoCsj/OedSiHcZPnbyy5/BH5dGfmlTXELqDtnb3ER4o7jeXJWkiXwPApsYe2ezO4WB1XNfHyybD6vJWrB8bzHqlBt2VQu0erM+u8ZmOTsJbGruTWNgmfKeLiYqZZ5/+Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(6916009)(2616005)(38100700002)(316002)(6486002)(86362001)(33656002)(8676002)(4326008)(66556008)(66476007)(66946007)(1076003)(508600001)(26005)(186003)(36756003)(6506007)(83380400001)(53546011)(7416002)(8936002)(6512007)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emVTbkNsc1dDZ0VJVmVjcnhNZHlBdjZXT3RxMlNwWG9jcENIS0F1blQ0S0h2?=
 =?utf-8?B?Y0hNTEp0MXpjRHFFcHNtM2ZNV1hRYzF2U2puUEEzNmg3MkJzaWl3TVg0Yjho?=
 =?utf-8?B?am9UdEhTbXlqUkZudlFNQUZZVTRPR2ZxRGlMUXg0ZlhVVVJtVlo4QnJubUM2?=
 =?utf-8?B?Q1hvTEExSk9FRE55aWhUb004NmVMdWVteUhaeUk5MUZEbkhENUk0T2ttWXJ1?=
 =?utf-8?B?MEVCSEJ2TTEwREpMcmo3c0NwdmZZOTNRRTZ0alJHalIrT3R1dFlsbHhuOWJs?=
 =?utf-8?B?OVlqZTBhcHJsRXJyK0hDL1YwcFRNbnRyOWp2RGw3R294SlpZclNMNVVsSllz?=
 =?utf-8?B?OS80TnY3ZXZrUGJQOFVaYTY3VW94cE5CYVZwV25uYW45VUF0bHo1VmQwb0da?=
 =?utf-8?B?dEEyRENaKzBmYnhyOWZkaW1QM3dYSUZaZ3loNnRzSHRtYmtJVXpkdk1NVWdy?=
 =?utf-8?B?Q2IyMHhiR05wQUdCN0JubUZCdE55enFTZVdTNHB6ZkpLalhNN0FyNFNjWWgz?=
 =?utf-8?B?dWVZdTRJbmVPa1RwdkN2Zm5KU3NYRXp4TU1Pb0NUemg0MlpNSVNuQkhzdlhw?=
 =?utf-8?B?UkVPd1RzRGIycmpxM0o4cENYK0QwREpBc2lTanp2WWRnSkxiVllQTS9RbVJF?=
 =?utf-8?B?YU5RcEUvU0J5alNBZ1lBaGRPMFkvcVNML0Iyb1VxTXNZYjJOQW9yTWY5b20r?=
 =?utf-8?B?RGkxam1BcFh2SGJOdUNKV25xZ1lKMUNGOGFSWlptNWtLNEZpVjdIRm04Y2Zz?=
 =?utf-8?B?UUkwN3BQSWQzWk1jK21QSmE2VmxTakJFUVhKVHBBamZ0YUV1bjk1YlRpdjhI?=
 =?utf-8?B?WXNVaE5FbFVTVmZ1NDBpaFd0NW90N1ZxV1Q4VjZWWXpqMFZ0ZStxZ0xYc3NN?=
 =?utf-8?B?d2dtOXdFZGxzM1Y0cGptYWxZM1Q3cWpGa1VZLzhyQTQwSFB4RkVRekh6Z2I4?=
 =?utf-8?B?N3BaYXZUTnNvSmVielV4Q0o0a01UWk53TFJqTXpKNFpkWDZWQ2JWKys5bitj?=
 =?utf-8?B?b0NxUEd3RDVpL0dOaTdodFFvdmpiM005Sko3U2IrQTF2QUwwd203dkxDU0FP?=
 =?utf-8?B?UmhmUzZseU05bmZHc2tCOGhnc2JCWitkdkd1S3p3VUx3cHZRRnIvaFdkZlM0?=
 =?utf-8?B?aUpxd29uazNucFBVTUVWNWYzL2Z2NEVwRlJvQ2ZzbVNFS3g3b3FNeXAvQWM4?=
 =?utf-8?B?OG41dzhoYVg5RStTUi9FT2F3UDNyelJDTkZTeWs3ZWs0aVpVa2duaDVhbXhy?=
 =?utf-8?B?Rm5oUVNGVWNiSGFESFgrODVpUDBUTVhSZSszbTlRYVVQcDlSNWxweThlMVp3?=
 =?utf-8?B?YXRJb0wxUi9xVFA2ajZyWHJUM1NMQyszTjdyYzFSeUlwQVhsUW5nK2hiWHlv?=
 =?utf-8?B?Z3pPUEFQZ2thZWFVQnYxd1l2OHg4VWRaaEZSVFVzVW8wVGp1UVZIR2JabGM3?=
 =?utf-8?B?RDlHVXI2QmlCaTVsY0xVTFQ2RG5LYXByM25UUTJHNG5TRnFQZkl3eGJzcFAr?=
 =?utf-8?B?Q3pJVXY0WE8zeEErOS9ja2NpRmlMN0pIRjdpMURaT0lYTWIyWHRwNjVIUExQ?=
 =?utf-8?B?TGdMT2p5eHc2UTBmT25UQlY0VVQvSytrNXZIS1diRHQ4blFmYVZRZWFyeXBx?=
 =?utf-8?B?emdLdDQwbDFGeGlJRThoeVZMclZ3ME16L2ZpdzJoVUxqV09EYzEvcUNqcW8y?=
 =?utf-8?B?bSs2MHVMRnAzRTkrekdOWWFpNzBsczd1NFkvMUw0UDlRZ0E5eVhRTXZxaXpK?=
 =?utf-8?B?bXF5MnJiVXg2V0ZrOTJWd09Gc0Vzb0ZwSDR0SHN2UnUzUlVKTnRoUUtrdzhC?=
 =?utf-8?B?QUg2QVBVVVpLc29iUG9PZmNoUHkvNmIzd3owZ2pmbnZlNGpzaVJ5VWtBSkVx?=
 =?utf-8?B?ZlpyMmpyTVZqSmxCQTNDOHZJSkkwYU1uOWJlaTZkZ3diS1VJWmRWR01oS2E3?=
 =?utf-8?B?MS9GcHRMeUMwcE9heVpMbCswNlF1NktPWkdIcnR5ODJXVmZWeDFVdlQrNytI?=
 =?utf-8?B?M2xneUN6R29wQ3N0cDJKakkyeElFbzQ1bllmVFUzZ1ZiODFHRTNtbEVkMENj?=
 =?utf-8?B?cEtzWFg0ektIM0U2L01BRGdJNm93NjhoRjl1Q3FUbmxrTTJDbE1PWWx1NlVD?=
 =?utf-8?B?eDZzQkRUNVVvbFArR3BvNE5IRUtCc1ZaVEw5bEx1MXFUdkRWa1dObkQxUk40?=
 =?utf-8?B?ZU5QdWtyY3d2OHVsQ3UrN2l0Q0VLRW5yWEw5a2JwYWhrRjhFY3B1eWhtUUZ6?=
 =?utf-8?B?K0k1anFmMnE0STNKSUlORmRpNmFOa3RXNEtTb3hlZnNBVHE4L0VrSVVYU2M1?=
 =?utf-8?B?RjdBMzJiN0o4WnZ3Tm54L05ibUtpS1JGSVNMUzBja3hmWCtETUVrZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b903fc-d9b8-481c-814c-08da10c717af
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:27:31.2178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvO72+Wpxjr333bkqeuGN2LaU5Q3U+SIRkB2wkfKDGyljJnyr8zd5EDgIe+LKYaK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5317
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 02:14:26PM +0100, Sean Mooney wrote:
> On Mon, 2022-03-28 at 09:53 +0800, Jason Wang wrote:
> > On Thu, Mar 24, 2022 at 7:46 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > 
> > > On Thu, Mar 24, 2022 at 11:50:47AM +0800, Jason Wang wrote:
> > > 
> > > > It's simply because we don't want to break existing userspace. [1]
> > > 
> > > I'm still waiting to hear what exactly breaks in real systems.
> > > 
> > > As I explained this is not a significant change, but it could break
> > > something in a few special scenarios.
> > > 
> > > Also the one place we do have ABI breaks is security, and ulimit is a
> > > security mechanism that isn't working right. So we do clearly need to
> > > understand *exactly* what real thing breaks - if anything.
> > > 
> > > Jason
> > > 
> > 
> > To tell the truth, I don't know. I remember that Openstack may do some
> > accounting so adding Sean for more comments. But we really can't image
> > openstack is the only userspace that may use this.
> sorry there is a lot of context to this discussion i have tried to read back the
> thread but i may have missed part of it.

Thanks Sean, this is quite interesting, though I'm not sure it
entirely reached the question

> tl;dr openstack does not currently track locked/pinned memory per
> use or per vm because we have no idea when libvirt will request it
> or how much is needed per device. when ulimits are configured today
> for nova/openstack its done at teh qemu user level outside of
> openstack in our installer tooling.  e.g. in tripleo the ulimits
> woudl be set on the nova_libvirt contaienr to constrain all vms
> spawned not per vm/process.

So, today, you expect the ulimit to be machine wide, like if your
machine has 1TB of memory you'd set the ulimit at 0.9 TB and you'd
like the stuff under to limit memory pinning to 0.9TB globally for all
qemus?

To be clear it doesn't work that way today at all, you might as well
just not bother setting ulimit to anything less than unlimited at the
openstack layer.

>    hard_limit
>    
>        The optional hard_limit element is the maximum memory the
>    guest can use. The units for this value are kibibytes
>    (i.e. blocks of 1024 bytes). Users of QEMU and KVM are strongly
>    advised not to set this limit as domain may get killed by the
>    kernel if the guess is too low, and determining the memory needed
>    for a process to run is an undecidable problem; that said, if you
>    already set locked in memory backing because your workload
>    demands it, you'll have to take into account the specifics of
>    your deployment and figure out a value for hard_limit that is
>    large enough to support the memory requirements of your guest,
>    but small enough to protect your host against a malicious guest
>    locking all memory.

And hard_limit is the ulimit that Alex was talking about?

So now we switched from talking about global per-user things to
per-qemu-instance things?

> we coudl not figure out how to automatically comptue a hard_limit in
> nova that would work for everyone and we felt exposign this to our
> users/operators was bit of a cop out when they likely cant caluate
> that properly either.

Not surprising..

> As a result we cant actully account for them
> today when schduilign workloads to a host. Im not sure this woudl
> chagne even if you exposed new user space apis unless we  had a way
> to inspect each VF to know how much locked memory that VF woudl need
> to lock?

We are not talking about a new uAPI we are talking about changing the
meaning of the existing ulimit. You can see it in your message above,
at the openstack level you were talking about global limits and then
in the libvirt level you are talking about per-qemu limits.

In the kernel both of these are being used by the same control and one
of the users is wrong.

The kernel consensus is that the ulimit is per-user and is used by all
kernel entities consistently

Currently vfio is different and uses it per-process and effectively
has its own private bucket.

When you talk about VDPA you start to see the problems here because
VPDA use a different accounting from VFIO. If you run VFIO and VDPA
together then you should need 2x the ulimit, but today you only need
1x because they don't share accounting buckets.

This also means the ulimit doesn't actually work the way it is
supposed to.

The question is how to fix it, if we do fix it, how much cares that
things work differently.

Jason

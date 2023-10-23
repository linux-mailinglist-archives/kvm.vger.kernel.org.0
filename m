Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBD17D2DE8
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 11:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjJWJQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbjJWJQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:16:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC131737
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:16:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39N6jGfd002756;
        Mon, 23 Oct 2023 09:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=mCN1KAIBOMZGyVEk27cL83tY4pq/EwCmC9c/CkzChpY=;
 b=WhfPn4xMfF52SgyrkfPUnZNcshN5WmyqMKNZHdNCmbKr3VOZ88k1/BGhPWPdflvGGtDh
 RyuVfL+Ag32l3qVIsUmuFKcOJ7JFEiaZz90LwgEqlUcBjf5ZJXeCIY+I8UhokdfTJxhD
 RsfrevH0K3+59UOpudzHMeWfw46tNVBqGqeOUgFrsGgh4NTJJGkA0IXo1YOewKUigNQE
 +s3VeVy40Rj4PusKno5AOftFBSatdhFQ+bULrqfWMH/0hL879Q99ZEDOGWzaKknZmH1J
 LePZLKvDA8r8cvDBQH9iGmP3oSSJBQf3c4flxhLEBDuYA4uXs664ZKgJ75xA5o8y6oAq hA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv6hajn9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 09:15:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39N7F7so015205;
        Mon, 23 Oct 2023 09:15:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv533qnnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 09:15:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQRL/0cIY8LSrRcjIvTV6U2UN6GN0MRMcLpW2h+XnlIrd5OaTOisnpZBusOUQW/pDuMGQatoacmJeTM400jzLscm6PUxsl7jazDxv5BuMbQO62i+hhsvRbcjyEbhAMb9DWDB0JLEq/xp38fbb9mdyubieldUpVneIacAgkQ0g1GsYuZw89vcpgqiKCv8xVJDgZVPCxd8yE9g6wQ1kfM742dScRUjfUOfZFIouJU/KszxzbW2JoDFAwg/hCJaSyEP9rgWAmCTM4tXqGRF238ilo/GysZ/dJ7EkuGeLwH0o7vi1Q9oDc65Nzz8uo6On8K4i8H+A/6qAF0ECy14Nf9DUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCN1KAIBOMZGyVEk27cL83tY4pq/EwCmC9c/CkzChpY=;
 b=EzRngDMR1Q8eJMLLIXYyZ3/QDqJiVoeWXNX0aZzf62FEM/xkzGnbgumrpsm2fGX8iYN/+17BPo74pNKbaHaNPfehKdRSq4v7CEDQw3SzUNHsFFsIIpBvkDMmqzB6FCr9w8JzLh3Nf/L310IkAgUOiGXvtvMKIBT5sgzL0euSRbBndFy+uuwhcfm8gqabW3EhO/pMohOu7UlL4RDS3GMqwX+581FBFtrQ6Z1IJIGhtoChfF8eA51tcYsq8uDpzMojz9ihOXeuinzvisPV6T4etrXbAyrdUYxBfNwJAEL1Y2FqNnwiLtuiNT06oCtotbu1JgK4yCgJnusH3x56gBRWWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCN1KAIBOMZGyVEk27cL83tY4pq/EwCmC9c/CkzChpY=;
 b=t/y8PP0LEpkgb28CMAp+Tl6rXxjgJYGBbOG3yyKQXA1h0ejIbAdU8V4sPLm20fNj9jPzaKH+cN0lHku3P5x1B7Gcm7Cp2Pf3kDXrYvNuJkyzlQBa5mWgE0kPevjXgLwcDZP7lh5TJIBZ41rCJ7/JCf4x5cShuvPIuVxI+doXykg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH3PR10MB7459.namprd10.prod.outlook.com (2603:10b6:610:160::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 09:15:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 09:15:29 +0000
Message-ID: <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
Date:   Mon, 23 Oct 2023 10:15:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com> <ZTXOJGKefAwH70M4@Asurada-Nvidia>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZTXOJGKefAwH70M4@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0239.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::13) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH3PR10MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b456055-eb74-4521-e162-08dbd3a899cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HnU+DcsXjULKPzjNaSkUUAt9WJn0feXPvKUo264BoPUohaR4n3wNuBa9Gg+zQSG4eHgySBduaOBR6fJgu1VKkshAb+eYyaOgdC6xPLGtZMIx6pawzCMYkgb2uwWMJQA4yjzStpW16tM0CU9rkSH3Wa15aPLfYk2EfCTu428kFILqH5dsDXUruvF4Uk8f3WQFIy5EUWyynqCGRav0fp+wTTvDG/8RmPXXtILxNlXZU7YbEYwnWAceQqNWrhpUcHaHgnFw2U+X9SnfQbm+/Eswg+pUq8o3gMfL5UTztccQUnki54twQoowN2VPVaDYTqTgE7tSFhSQOukSwERGsMbWaO4yXv48RR4Q38xTcppO8JOr2G7V99RN6SsVEJJXT6PTqjn/EKQibUhgJChPPZ7p/R1DC9VoLTWCaf49RG5VoeGBZHDJqXk2sJq7Mjruq2/1DnflkTQw431TKVyWNa3MVApgYTAK0A8mkE9mVf5gd0Imn1NpC//ndQ8TpAkCPrmFoknI4axQyHWj4bbWP+StBIVACDe1GhbmX4xsxkcwyeBC9OUmYVTIltnSQj57iqiXSq/Ur1J6HoapWGK5KXQWmiNFNo4PvkrZeygIgHLP8EecD65a26KB94DmglXcECePEgeYnHt78koNxIt4wFnXyfDe1z97u0diTVFsigS4NxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(396003)(366004)(376002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(31686004)(54906003)(66556008)(316002)(66476007)(66946007)(110136005)(83380400001)(26005)(2616005)(6666004)(53546011)(6512007)(6506007)(478600001)(8676002)(8936002)(4326008)(36756003)(5660300002)(38100700002)(7416002)(86362001)(31696002)(41300700001)(2906002)(6486002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2tWQjA4Y0RkRnU0MmpMcDBVWUpKNENMVWVabndEOWluZWhuVzhXRHA1WklN?=
 =?utf-8?B?MS9NcVA0YzdJQTZrakxWQ1ZRQnFINE5pV0pKbmtQRVBYUzZFTjFEdFNLOW54?=
 =?utf-8?B?V3hMUTNYaDNzMzVtL05iclVCOVlTZUU3NmUzSXNnQjd3a2lUQ1FWUkU0WEx3?=
 =?utf-8?B?bVRBYmljeVFsbnhmVURFQzFreGw5V3VyUFJybGhFL04rK29MOUorU1NibGEw?=
 =?utf-8?B?L3g1TzJqaTY3ejFZNjFjdFVJazFRTjVJcjVFSEg0U2VxWmNLV08yaEFZZ3Nn?=
 =?utf-8?B?djJ2NmR2dC9OdVF4K0wwYmZSQlFBM0plU1hBVnJxWUMrWkRjNlF1MGQ0T3l4?=
 =?utf-8?B?Nm5LV1F0MmxiNDdrRVZDVlVGSkRlc3EwQVgwdS9nZ3g2VVFaemJrZTJNZEdS?=
 =?utf-8?B?N3pXd3RZcTdUekI3ZGRNc0tNT1YybFUvSHlSZ3hGeTZJL01wOGpidGQyUkxX?=
 =?utf-8?B?Kzg3TWlsVWZQQlJwZmlaNjJic2pZVHM4VVJHeFhLaWFtam9VQ2trOHZxUGVj?=
 =?utf-8?B?L1pIUitpaHgydy9xd2lUUUE1ci9neXdYSGphOVdRTkFTWCtYSTU1ZEdyOU41?=
 =?utf-8?B?SHBmSkdnZVlrTWx4U1k5V3J0VllyZXRPbytSeFBPdmdoTjZyV2V4UEcvM2lD?=
 =?utf-8?B?SEVXTG5xbGlubEFLM0d0NkVPelc0Tnpld2JRV2JJcHJ0TGV2akNTNFduaWdO?=
 =?utf-8?B?S0xxaThCeHNsakd6NTU0Tkl0ejM3QXZPcGdBNE1EK2xNTCtDM09ibVd1WEoz?=
 =?utf-8?B?SFRYZTBxRTVVVEVzaVFsWjd6cEZDK3ljZHJEdmJWTFFDNmpkdmx3VkdVVm9M?=
 =?utf-8?B?WkFEU0pJWmlYVzdQY3hTTFZIbVFaZjB6SDlqMG44amgycSt4RnRFaW1WZ3RQ?=
 =?utf-8?B?SmVkMnB5THJ3SG51Zit2c3lnTjV6VlFrREFCUVRTMGQxQXBtT1plbFlBOFR1?=
 =?utf-8?B?dDd1U042bEIxTElWTnJvVXptWVRFOHpOMEFSOXo3KzlxQ0ZxTitYdlFQRDVV?=
 =?utf-8?B?ZW5YNlhtODFnY2FBaHRmSGVHVk9zKzRGNTJmMHRmQzBlZEJwd1JGaVlXdHdE?=
 =?utf-8?B?MVJaUGRvOHZhdW5RcVkybE0rOTZmWmE1dXNJNFMvZlVZaGtPTUNSa1VGOXJM?=
 =?utf-8?B?NWtjWGNlaStlNDRjTCtvK2Z4aVhVR3IxNnFpeDA1aXVOOVMyNUwvLzVuMDVa?=
 =?utf-8?B?VnBHYVRCNkdMQnloNlRCNnlRM3RpZFN5Zm1zVWl4a2ZkK0diQUlJeTBtOGZl?=
 =?utf-8?B?RTNsU3JRSzZuZlV1cytIVjZHR3ZtemIxMVJqT1VVSkVWSzVSek1vZnVwZlha?=
 =?utf-8?B?VXE4TGVVS2lUU1pzVXU3OEtoWDFiT0ZWSi83UmNHeHltaWlQeU1VK1pwVEVp?=
 =?utf-8?B?SkJSWFdVQ2Z2dkdkK2JXbS9yaHI1QlhFaWticFpUcHRmcW4rTUlSUHZIUnhH?=
 =?utf-8?B?MmpSNVZLckZrZWI1OEVNMGIvRDA5OTJsRGdaUWxHV1VEaSs5dlQ1WjJDY2NQ?=
 =?utf-8?B?NENPb2kxMHloOFVpNE9JaDZ0RWZwa0haVEZvUjFTMUNJbVQ0Yjg4UDNFMXpV?=
 =?utf-8?B?blhUNVV1dDNMWkdWUTcyMG85cHNBTnFCNlhpaktVR0kxc2JMR1Y1NkxJSmtN?=
 =?utf-8?B?bGFJMi9ZYU52TDNuYjI1QTJGMVBGU01lNUpPQjdud1QyRDlxTUkwR3BBVE53?=
 =?utf-8?B?aXBYU3V6YXhIaWdpbXdHUzBiT2EzY3VrK1BSa0d0aEJjUkVHVnhCWFBPOGpq?=
 =?utf-8?B?dThiTXFjT3BxcXZOYWRWUlZPVGVRSXpaNld0d2duZ1E5RUd0VXhtWStuNGZx?=
 =?utf-8?B?ZVhpNElsOFBUamg4ZXBiNmFOUHJJczVqRjZsZ21LQ1BLcXpCcnphUUE5U2xo?=
 =?utf-8?B?bnlTdVh0K2xyQ3BtSWNaVWp6TFZrV0R4R0Q1L2pMb0VXdk1JeUM5NURUZjNT?=
 =?utf-8?B?MXEzRHdQa1BrbzhuNjArQndBVE56STlDWVN1UThuVWgxLzhDQzlsRTZ2SGFU?=
 =?utf-8?B?WWJTYmpLOFE5eHpIdXJSME9yakpUMjFZSXZ6QnBPa0JEMGhtQ2x2c1ZoNGtl?=
 =?utf-8?B?Q2RkWWJTanlrdlRRNXk1T1g3YjI5RzhWaThQMkxnaWsrY3E1Z25nWXZTazJN?=
 =?utf-8?B?MEd6SWdMaFQwYWtmdDVNMnFxVStHcVY0SjdMa1ZHY2p4QWhVRGdoenlwOXFW?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WE1FdmtrTmFYTHROT3U5cjd6Z0RwdlU3VXF4MUhkM3BEWkFXd0lmQktEblh5?=
 =?utf-8?B?bVllbUR6U1pFYko2b1phdU11V2d4TzB5bE1XQ1M4Q0RLRE52TW5rMFRDUHJ4?=
 =?utf-8?B?MTVDYlVmZ2dYTk9VeHZGbVIxUjJDd2tBMEpUR0ZCYTBHZ1o0bFVndWlCSmVm?=
 =?utf-8?B?YWFxbmFwWFpET1BIV0hoV1hMKzd6OFllSjREeCthb0YydkdXM0pOSldQdEIx?=
 =?utf-8?B?VWFDZkRWQjZ4anZFQnh6K1pMblkzNU5ZaXV3NmtxVlB1UUtqSllIb09XRzVt?=
 =?utf-8?B?K2txeTYvazBFZ3pOcEttaTR0aklrS2Y5bEMvSUVzTldZd0YrUW5NVisxNVFx?=
 =?utf-8?B?ZXFiQlhIUmRXblI0OUtQUit1VHVXV2lJRk1OQ0xReit5ZUlLVjBFVkhSMWhB?=
 =?utf-8?B?VDlXbVpyUnNhVzBMc0ZrWE1wNjZ4NWJFeTVRdjAzOXZFT2wrcE1IQ2ZnUGVj?=
 =?utf-8?B?eGhsRDdEbXF3SzFOOXlFRFRVU0lFNzM5aHBSMHZWTlArNFoxek5WOUFrZ0Rs?=
 =?utf-8?B?RlFGNkZJMVplRFMzNW1NUHlQVlRFOVA0WThMNlIzTWFka2loSlp4Vmp1SUtx?=
 =?utf-8?B?cCtRMWhDUjROTXRKRzNyMDZSbUpoWTRuSzZ2Z0RVNVJSTHI5OUEySzV5MW5Y?=
 =?utf-8?B?UzZrSFFScDNGclMwaFdrS0ExcGhYb2h3UE0xMmtlZVN4ZEJEV2Y3aWk2MjlH?=
 =?utf-8?B?algzVWJJR1BUNjNuK1M1dEVrY3dyaXYwMUxtRGorZFk5Y2lWVTIrSll0WjRn?=
 =?utf-8?B?dENUNEZta21mYStEUHp1MnhGdkdIRWxlNi83blp0dFZ1bGI3aVI2QjRzTjBi?=
 =?utf-8?B?K25XeUV3WU1VVk5McFIxTGdNQklVT05pVzhoamhDUnZXOHpnVG51VHZaSlVB?=
 =?utf-8?B?QkJUNFdMa2VXVElzU1dFTFNPR2hLN1lndEFSM0FFbytCSFBpYXFzNGpvaGpK?=
 =?utf-8?B?WDN5UnJKTTJ6cTlqMDdpMmM3WU1qLzVYVFE1N2VzV0NuS3FXL2xlU2phNnpS?=
 =?utf-8?B?S3ZTalVNTlVkbXJhS2VIL0sveWtHWDlNaTlmdDNuVVZmbU9WSERqek8rejBr?=
 =?utf-8?B?eXgvWG1YTFd3UXlQRWIzTHpzMUpXS3lSdTdGdURrUUF0Z0JwMEJhNmNQc0pK?=
 =?utf-8?B?YnpNRDlDM2k5VVgrS3NNc0I4UE5Tc2t3QnRxblZXWWtjK2p4anNrT0l3RVA4?=
 =?utf-8?B?ZTVRVERuemVqZkNkR09vaU8vRVlHWUliVlN2dk5kK1c4OTZOSjlnUkFxV2tz?=
 =?utf-8?B?UkxPaGFOUHpic2RMWE43eHFkdVRZRXBpSEh0TmJhUkx2UlZDWEdRTjU3emdJ?=
 =?utf-8?B?WGFkVVJleUl4ekNxRU9UZC9iaDdJRld3aWVWZGlya3hRSDhJbXlLa2JHWnAy?=
 =?utf-8?B?TGhSWEtYcUU0YTl3RFhqU3lwTUttamhvak5jc0RyUnRsWFpRMmszZERrbDVh?=
 =?utf-8?Q?ilhU56QE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b456055-eb74-4521-e162-08dbd3a899cc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 09:15:29.3386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeIedF0/6796qTZYoK7V0vNufM+eQO6fdlLxD28wHVN/po7IW3lplYdNaEEel6QDHns8e61cYDkqIcStbiJF8QnpScfEA399gtVtR48hqMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_07,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310230078
X-Proofpoint-GUID: bV7yLiE2yKMb6UyRWGGyLcvxisPbl7U3
X-Proofpoint-ORIG-GUID: bV7yLiE2yKMb6UyRWGGyLcvxisPbl7U3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 02:36, Nicolin Chen wrote:
> On Sat, Oct 21, 2023 at 01:23:21PM -0300, Jason Gunthorpe wrote:
>> On Fri, Oct 20, 2023 at 11:27:46PM +0100, Joao Martins wrote:
>>> Changes since v4[8]:
>>> * Rename HWPT_SET_DIRTY to HWPT_SET_DIRTY_TRACKING 
>>> * Rename IOMMU_CAP_DIRTY to IOMMU_CAP_DIRTY_TRACKING
>>> * Rename HWPT_GET_DIRTY_IOVA to HWPT_GET_DIRTY_BITMAP
>>> * Rename IOMMU_HWPT_ALLOC_ENFORCE_DIRTY to IOMMU_HWPT_ALLOC_DIRTY_TRACKING
>>>   including commit messages, code comments. Additionally change the
>>>   variable in drivers from enforce_dirty to dirty_tracking.
>>> * Reflect all the mass renaming in commit messages/structs/docs.
>>> * Fix the enums prefix to be IOMMU_HWPT like everyone else
>>> * UAPI docs fixes/spelling and minor consistency issues/adjustments
>>> * Change function exit style in __iommu_read_and_clear_dirty to return
>>>   right away instead of storing ret and returning at the end.
>>> * Check 0 page_size and replace find-first-bit + left-shift with a
>>>   simple divide in iommufd_check_iova_range()
>>> * Handle empty iommu domains when setting dirty tracking in intel-iommu;
>>>   Verified and amd-iommu was already the case.
>>> * Remove unnecessary extra check for PGTT type
>>> * Fix comment on function clearing the SLADE bit
>>> * Fix wrong check that validates domain_alloc_user()
>>>   accepted flags in amd-iommu driver
>>> * Skip IOTLB domain flush if no devices exist on the iommu domain,
>>> while setting dirty tracking in amd-iommu driver.
>>> * Collect Reviewed-by tags by Jason, Lu Baolu, Brett, Kevin, Alex
>>
>> I put this toward linux-next, let's see if we need a v6 next week with
>> any remaining items.
> 
> The selftest seems to be broken with this series:
> 
> In file included from iommufd.c:10:0:
> iommufd_utils.h:12:10: fatal error: linux/bitmap.h: No such file or directory
>  #include <linux/bitmap.h>
>           ^~~~~~~~~~~~~~~~
> In file included from iommufd.c:10:0:
> iommufd_utils.h:12:10: fatal error: linux/bitops.h: No such file or directory
>  #include <linux/bitops.h>
>           ^~~~~~~~~~~~~~~~
> compilation terminated.
> 
> Some of the tests are using kernel functions from these two headers
> so I am not sure how to do any quick fix...

Sorry for the oversight.

It comes from the GET_DIRTY_BITMAP selftest ("iommufd/selftest: Test
IOMMU_HWPT_GET_DIRTY_BITMAP") because I use test_bit/set_bit/BITS_PER_BYTE in
bitmap validation to make sure all the bits are set/unset as expected. I think
some time ago I had an issue on my environment that the selftests didn't build
in-tree with the kernel unless it has the kernel headers installed in the
system/path (between before/after commit 0d7a91678aaa ("selftests: iommu: Use
installed kernel headers search path")) so I was mistakenly using:

CFLAGS="-I../../../../tools/include/ -I../../../../include/uapi/
-I../../../../include/"

Just for the iommufd selftests, to replace what was prior to the commit plus
`tools/include`:

diff --git a/tools/testing/selftests/iommu/Makefile
b/tools/testing/selftests/iommu/Makefile
index 7cb74d26f141..32c5fdfd0eef 100644
--- a/tools/testing/selftests/iommu/Makefile
+++ b/tools/testing/selftests/iommu/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -Wall -O2 -Wno-unused-function
-CFLAGS += -I../../../../include/uapi/
-CFLAGS += -I../../../../include/
+CFLAGS += $(KHDR_INCLUDES)

... Which is what is masking your reported build problem for me.
[The tests will build and run fine though once having the above]

The usage of non UAPI kernel headers in selftests isn't unprecedented as I
understand (if you grep for 'linux/bitmap.h') you will see a whole bunch. But
maybe it isn't supposed to be used. Nonetheless the brokeness assumption was on
my environment, and I have fixed up the environment now. Except for the above
that you are reporting

Perhaps the simpler change is to just import those two functions into the
iommufd_util.h, since the selftest doesn't require any other non-UAPI headers. I
have also had a couple more warnings/issues (in other patches), so I will need a
v6 address to address everything.

	Joao

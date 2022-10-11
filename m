Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A415FBC0F
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 22:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiJKUbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 16:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJKUbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 16:31:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9905E676
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 13:31:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BKTMDD021452;
        Tue, 11 Oct 2022 20:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=hKwJl63OzVcrJ6rNIPuzkXywhYa7Ts9e1NjES1t1VUw=;
 b=lxX639cKLx989b3V0lt9/9jjFRE0yHmHI4ySkbYnpMus5jPR0MLfPNwxfE4yQjoR72ps
 J7iSNNtFdjC7OsoQm2nDMqfIetf1RNVOFu/KXyxqG/vJu9SiNuBm4k26O/0iBLt+etit
 7+c/3okKRij/svZHGqxVfdUwFik9s/wQRaoF7iUE4t165TrP+LUThOnX+1R51JNa0DRd
 E5eJfjfoa3Hs6El+pA4DVuy2afo9lagVAtd71Ipsp/1BdndMAjwht7486/fdblxqyhAg
 lgTon3ZBF7SoseW0oVIjg0agWSqftBS1z26ni/4ijao5TfoPJabbqi+F2BEnNH88XhnE iQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k2yt1g40v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 20:31:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29BKQeb9028537;
        Tue, 11 Oct 2022 20:31:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2ynask3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 20:31:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSzNGEB43cGIo5TqgdvEiaKebTyEPdLHhy2XrwIOB+RKVFdBlrZcAKkH5cRtysFDIW2X1X2RM3WPGmPRu8f/AVq2mxTxR99Cimrt+4mZ97lgUlaXYjC5HmduvZnUgejyh3OFg8X4Weve3qT2j39EQMH0zNZz27Ow3WO1eeDIpGt7UXVp5ZQTz8kgwg0g+OH244C23PF2eZfUwZ4Fh51Yore/g859xehm+BQ0a5AKsnLnEzgEsQV34Znf8dkJA5OGmNpkDZtrhK/tQtUezk/9WZO+/Xql7QIImU10+6YQmsjuPKrPSNP2KxTYpGD6EQ+RmsHvrUDABoFoCkop131B+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKwJl63OzVcrJ6rNIPuzkXywhYa7Ts9e1NjES1t1VUw=;
 b=YR6cXzhtbSC6LHP0/VFDiQxnwQCYWnvokCLWtjRkPMEtC98Sn46eBJhfN3EutqH3GkyTNcbMMuTsUKzNLTeiVpWm5PY4Wbghhbdg15INJqW/f+QTULMvvSwbnpAPb72a/i6ZlNgukgqAohXO+mCtg93Ww+B9XwR0SSQEiVlDkFm2iyxpvsC/xGPvKfVMEYqXypBVZOo0TeHvkkjcxnqp0fgtL/WZHFseP4/gkiDgOkzsdITZRJNwnAN5LfLSQIqe1FVRcusodQ9tMtoG4V4edz3ymXv55B2JYkwsdbt694dYv4JrRVwIuKa8oCUO1YGEyL/aWeKVZquCoIZpFg0EOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKwJl63OzVcrJ6rNIPuzkXywhYa7Ts9e1NjES1t1VUw=;
 b=UxmmCAXHBhO3IVC1BZe9/laHPbB8rYwfot7/VbqIxROID4g5MFV+hoAlY12nKsUpSM9/3+2G0F98Db0eOsnOliy0cXfV+Y4fjPy74O0xK18hwVwh3h54hEq5aFm9D9yj2SCc1T78zMMQEVEBc+45aiQ/VVVN0ysuR5KaQuoOS1A=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by SN7PR10MB6644.namprd10.prod.outlook.com (2603:10b6:806:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Tue, 11 Oct
 2022 20:31:05 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528%4]) with mapi id 15.20.5709.015; Tue, 11 Oct 2022
 20:31:04 +0000
Message-ID: <634a8f2f-a025-6c74-7e5f-f3d99448dd4a@oracle.com>
Date:   Tue, 11 Oct 2022 16:30:58 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com> <Yz777bJZjTyLrHEQ@nvidia.com>
 <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
 <Y0Vh868qUQPazQlr@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y0Vh868qUQPazQlr@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0133.namprd11.prod.outlook.com
 (2603:10b6:806:131::18) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3240:EE_|SN7PR10MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: 43975a59-ddcf-4181-3d79-08daabc7846b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Op48yECK7+DNTaMoXX3fFtZi0xd2s+223jvMLPZz89+vvIv1M57xjD5PNcNr5w0Qc3x8jRcRIaOy7cAie8AsMvjSn6fnMc+JPgxzJFNMlisvPHEcItjEu9vn2CWYaLmvYoBt/v9uBWQLiUfV+GpAKOalw8BWVZZstlLA5FHYBArwtUItgqmTNsMf8+/ZGH9cnS5dFBHU9aWVZBbB/yif5lKhTnYNezMmA4Y7rADAdEOXg0DRg405/TGeoVx5EPwl6nnmwPUmhVPf05J5PoHhYqG7RQYzMbmVpRENafks/uac+Biqt/ZRNzq+QwlM30jQ2hL7/U1tTyhXmCNJqFJxAL29wtcZzaTe0RdT85W/atWjkGNiFV+uyrN/P+L2BwwwROJjzxC+AtGEBlOp/19oGdjeaRt/+tCDKQIXNfI724EPh0UEla6tNe5oC+KBQhU/XP00dUJoFOx5RnPdj1sQUGJ1EdH6uEU8Hiw/WvAQ8Z0KO31MEyhI66AAwM7qsNpeVrTt4vxeZDRNGWdrzh+pnivQMXnstkUMfhbA3JKAz4jgxBowW7Y+Lx4mM4kuLXExnMjANRpN3HLOFivjZW74ykWWh/z9AuCHKL1gi30Rl5XQiJ8p05Xfn4/xYIRjkAic6nKIUHyDmS5JdxLzdHGTOMejISsJ8XtcTLfperFhGsygQKKZkf6Tu9m/XiglG3lzZaVd6OqQVGOMSqSn+oxZi7QO2d+LiYVa2EevCTpr6gbrAjimo++Uv/W4+CeCVn36Hh+GirwVhVvkTNziCPZPpEemstHG2oHK5B08bzImYI9++iNUetIOy8fzb5w7Zof1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199015)(31686004)(36756003)(41300700001)(53546011)(2616005)(26005)(6506007)(6512007)(6486002)(66946007)(66556008)(66476007)(478600001)(8676002)(4326008)(38100700002)(86362001)(31696002)(186003)(83380400001)(44832011)(8936002)(5660300002)(7416002)(54906003)(6916009)(2906002)(6666004)(316002)(36916002)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjVhc0V1RXVmd2Rhc004RVFRd2xzTUVsRWJXbFBOSExLVjJnZStOTkVqWkp3?=
 =?utf-8?B?MVp3OXZYdjhaU1ZIeHR3ZndrWjZreGl1NTQ2OEJBa0VGK29IcFdBai9WR3g5?=
 =?utf-8?B?ZExGbmoxOTJkbFBsV1g4VXJScW1XQ2p6dnNlZWpML20rRVNWSXVtbXJzS2Q1?=
 =?utf-8?B?YWYrcy85c3JraE5vVWNRdVB4SlhvVzRRbEFFd3RuSkt0eDQxQWVZZEhhdmts?=
 =?utf-8?B?VlpGdG82Z0lhRDlRTWdlQ2RUUXF5OGhUK3pnZDBDM2FnUWprOVhTc0dYdHZX?=
 =?utf-8?B?ckVWMjJPTzBsME1QbEkzSWI3amZQM1JwN3E0VEdnZlgzVHpwUmlya05zaUdW?=
 =?utf-8?B?bEQ0V1B1VEI0VklaekNJQ3JyWVdCaUs0cTZRcXhGem1EU2ZsTlhzakcyMnFO?=
 =?utf-8?B?RlBFSHcrU3MxMVJPLy95YTlyK2F3WmI1a1c1VWFRUjVoQmdGSFVkblhRUWMz?=
 =?utf-8?B?WlJZOExEZ3NXdld6OWJ4N2xQUW5zUTJlUDFuVXFuZDdxdUFQN3psVFh4RlRW?=
 =?utf-8?B?SmZZU3BDdTFIS1Nra1F0eGg1VVJNa0RJeFZLbmYyejFhZWlpSkpwV0JBeTZm?=
 =?utf-8?B?dm9mM291OVNxeGkwd3BiT1paSlh2MzBIb3pNKzRQUUozU0xqaGFZY2tUYnpN?=
 =?utf-8?B?S2ZSWDBZYWZqL1JSSXFlUWp5VWxhN01SeURKdmJGRlM4SDByNW1IZUxRLzJw?=
 =?utf-8?B?d0FGUjRrQWU3YU1mRmxVVDVaWVFuYk9rdmtNNlVsRENXQXhNRXJFQmFhMThL?=
 =?utf-8?B?dysxVXRkT3plVVVHdVE3SCtEK1QzcThTeGI5blQxREpyNXc0YkpFMUxhdy80?=
 =?utf-8?B?M0h3MVNvZHhFMWZFeWpNL1QxdW1wWmFqZzFRcHlCOVRoZzdzY0l1bUkybSto?=
 =?utf-8?B?aDMvM3JUZU8zTHA2RksrQU00ZmdZWGd5cVVsMFdJVTYxdTJQK2h2OUFKQ3N0?=
 =?utf-8?B?K2RxZXZxNUZzOE5KSTdjWVk1WEpwSUswK3YrZ3BKbXNLTEFqZmw1bytBNVNy?=
 =?utf-8?B?NkVKc0srRlVzUXFzcm9XNm5wYWxkVWNxRGdvWEdEWHl6SkUwb1UxNThkNUs1?=
 =?utf-8?B?bDBVRGVQb0JhcklmNDFzdUFlOXJYbDhMSzcvMlo4T0ZTdjk5eGRBYWlOeWMx?=
 =?utf-8?B?SklKeitaRmVXNlZSTmJtR1d5dmo2WmZwR00zZHhKeHZIY29uRDNIZEk3N0dF?=
 =?utf-8?B?SnhUZnJwL3Yrb01XZ2czWXdlUTE0L28zZloyVENmdnZaVnBTRWljSk83UVpT?=
 =?utf-8?B?SUVqZnVMUjI2TTJZK2o1UkJENXRVRXlaRjlVaUtESFJ0dEFpQllEL0NZZGhm?=
 =?utf-8?B?MEhPNkN3SzhBWFQrcHpDeGI4dGVwQVc2VlpQWHF0bytibldVdEJWbGREampD?=
 =?utf-8?B?ME94VitxYkd5U3M4VDdzeXdRUnZjeERuaXdEaDVFZnEzaDJhbTY0MWF2T29w?=
 =?utf-8?B?RzFEQ1ZEb0NGVWt4TFNrOFBTZEoyOXdqTTJ3TzcyRHJkSnR1M1hyQTNhZ2x6?=
 =?utf-8?B?eThhY29hdVQ0MFpHTm0vM3AyeSsrNkhvUnphT1hpVzR0dFk0aGtNaWsyVHU4?=
 =?utf-8?B?eG5wQ0tqOStqbHFOL0tGTWpHM3o0TzBtK3hRVUNrNzV3UDd3MHdwTGRIMUtn?=
 =?utf-8?B?YnVqUnFsMENYZHZqYVlmdm85SU1BcG04Ni9iSGJhSVR3OG1vek4ydjdtdElP?=
 =?utf-8?B?Qm1OQ0R0akFaUDN1eGtKRHhwNmpKSWJuTnJ6THV2dnl5MzJuUktxdGlrUFpi?=
 =?utf-8?B?MWdnUDVXdFNQcG1zd3U2QlBTcVB2b3dFLzdVUVRIMklveDhOUTM4bVI3Q3ZV?=
 =?utf-8?B?R3hDU2RabzdmZGszNTFYaG1VRisxKzc5dk5VUENQZ0JkR3k4VExMenBQbnpL?=
 =?utf-8?B?SzNwZFNvaHpyQW41a0xvL2pERGoxYTh3N3Q4U1ZIVjhIb3lHcHN3OXFIcmcx?=
 =?utf-8?B?TG1LZnc5MlJVQ1FzTGxDUWNQd0VKNHZKZ2tRZkxmUXQwa2hPOEUrcDE3K2d5?=
 =?utf-8?B?eFJlSEJESkFQN2psMVYzTS9GZUxlbnZDV2NaMFZvN0lHZ2JKR3ZZaDRiNzJK?=
 =?utf-8?B?NVorSWc1YmtDYXNqZTdWR2FUVVZ5a3JvZ3B6ZjJFdW1KcFFJbHlxNzBFRVJV?=
 =?utf-8?B?Rk16K2dRRGIwYTd5Y0dCUkNLSDlmNTE1dTd4ZlFBQkxKdm1VWFN0djVKTFpi?=
 =?utf-8?B?aVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43975a59-ddcf-4181-3d79-08daabc7846b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 20:31:04.6682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHD5oEXx+ru9M2ehIz58TIYQRdzdtWmYilwF7K5gpDZzvmP+zoFT/Avhm0voXnpuOaKy/ty/vxKvzKwCUuGrRyEAQQkPSQm0bYeXV+N/r4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6644
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110120
X-Proofpoint-GUID: czHGVwdNi_ZTYW4Pvp2DbfSEFuQmDZvr
X-Proofpoint-ORIG-GUID: czHGVwdNi_ZTYW4Pvp2DbfSEFuQmDZvr
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/2022 8:30 AM, Jason Gunthorpe wrote:
> On Mon, Oct 10, 2022 at 04:54:50PM -0400, Steven Sistare wrote:
>>> Do we have a solution to this?
>>>
>>> If not I would like to make a patch removing VFIO_DMA_UNMAP_FLAG_VADDR
>>>
>>> Aside from the approach to use the FD, another idea is to just use
>>> fork.
>>>
>>> qemu would do something like
>>>
>>>  .. stop all container ioctl activity ..
>>>  fork()
>>>     ioctl(CHANGE_MM) // switch all maps to this mm
>>>     .. signal parent.. 
>>>     .. wait parent..
>>>     exit(0)
>>>  .. wait child ..
>>>  exec()
>>>  ioctl(CHANGE_MM) // switch all maps to this mm
>>>  ..signal child..
>>>  waitpid(childpid)
>>>
>>> This way the kernel is never left without a page provider for the
>>> maps, the dummy mm_struct belonging to the fork will serve that role
>>> for the gap.
>>>
>>> And the above is only required if we have mdevs, so we could imagine
>>> userspace optimizing it away for, eg vfio-pci only cases.
>>>
>>> It is not as efficient as using a FD backing, but this is super easy
>>> to implement in the kernel.
>>
>> I propose to avoid deadlock for mediated devices as follows.  Currently, an
>> mdev calling vfio_pin_pages blocks in vfio_wait while VFIO_DMA_UNMAP_FLAG_VADDR
>> is asserted.
>>
>>   * In vfio_wait, I will maintain a list of waiters, each list element
>>     consisting of (task, mdev, close_flag=false).
>>
>>   * When the vfio device descriptor is closed, vfio_device_fops_release
>>     will notify the vfio_iommu driver, which will find the mdev on the waiters
>>     list, set elem->close_flag=true, and call wake_up_process for the task.
> 
> This alone is not sufficient, the mdev driver can continue to
> establish new mappings until it's close_device function
> returns. Killing only existing mappings is racy.
> 
> I think you are focusing on the one issue I pointed at, as I said, I'm
> sure there are more ways than just close to abuse this functionality
> to deadlock the kernel.
> 
> I continue to prefer we remove it completely and do something more
> robust. I suggested two options.

It's not racy.  New pin requests also land in vfio_wait if any vaddr's have
been invalidated in any vfio_dma in the iommu.  See
  vfio_iommu_type1_pin_pages()
    if (iommu->vaddr_invalid_count)
      vfio_find_dma_valid()
        vfio_wait()

However, I will investigate saving a reference to the file object in the vfio_dma
(for mappings backed by a file) and using that to translate IOVA's.  I think that
will be easier to use than fork/CHANGE_MM/exec, and may even be easier to use
than VFIO_DMA_UNMAP_FLAG_VADDR.  To be continued.

- Steve

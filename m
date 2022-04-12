Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3114FD98D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 12:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351661AbiDLJ5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 05:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356529AbiDLIKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 04:10:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8183CB44;
        Tue, 12 Apr 2022 00:41:38 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C5JJsP012716;
        Tue, 12 Apr 2022 07:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=fLmmftGwcRhoo/l+B7FqNuSpBchdixeaCTamtoLnkcI=;
 b=IQWeoYr7U49SRYZLU9AiY7veD1LHy/7Mli6ZgqTOw+x1iJq5imqVpABBwjxBe9Akgl/G
 AWjU/qRQWTVIOQAPnYEVxX8VSDPQ5Dt2WOGUpJ5RRt3K1x0F4aI3F48YzM0JWcnSM2ll
 xW0pFRh9uGN6qpq4QV1altHz0nlEi5ee5PB6a0sP5HMWSYq90kk8OUsfzGDALVZCuSnr
 OhNL3/FSVOVzfCp5yiH46On0e8sljJLDclY0iNqdAJzqisvQKtkKLjZKiUM/wzkZagqn
 KItG3JgWW69mKt0eekCd0U73VdgFvgOiKIbU6jsodIf50KFfK0UdO9llkpQhuQXjSbJl AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd360jmrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 07:41:37 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23C609WR014162;
        Tue, 12 Apr 2022 07:41:37 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd360jmq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 07:41:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23C7Ru7f006315;
        Tue, 12 Apr 2022 07:41:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3fb1s8kgxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 07:41:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23C7T3JR52232604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:29:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBA7C4C044;
        Tue, 12 Apr 2022 07:41:31 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 681FC4C040;
        Tue, 12 Apr 2022 07:41:31 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.29.167])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 07:41:31 +0000 (GMT)
Message-ID: <4b7a793f9ab64eb6c5375a12844006bc86c0c752.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add selftest for migration
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
Date:   Tue, 12 Apr 2022 09:41:30 +0200
In-Reply-To: <5073d0fc-1017-5be6-2ec5-2709be14c93c@redhat.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
         <20220411100750.2868587-5-nrb@linux.ibm.com>
         <5073d0fc-1017-5be6-2ec5-2709be14c93c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3bjjQ6OXeg_NZncsDGsannmTM3uZVA4E
X-Proofpoint-GUID: F_CFr8Q2WXRhoZTkgttzTBB_1Fl3T-aO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-12_02,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-04-11 at 17:30 +0200, Thomas Huth wrote:
> Thanks for tackling this!
> 
> Having written powerpc/sprs.c in the past, I've got one question /
> request:
> 
> Could we turn this into a "real" test immediately? E.g. write a sane
> value 
> to all control registers that are currently not in use by the k-u-t
> before 
> migration, and then check whether the values are still in there after
> migration? Maybe also some vector registers and the "guarded storage
> control"?
> ... or is this rather something for a later update?

My plan was to first add the infrastructure for migration tests
including the selftest and then later one by one add "real" tests. 

But if you think it is preferable, I can extend the scope and add some
inital "real" tests in this series.

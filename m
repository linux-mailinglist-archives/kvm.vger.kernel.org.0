Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C55D4E8FA6
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiC1IDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 04:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbiC1IDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 04:03:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A2952E7B;
        Mon, 28 Mar 2022 01:01:50 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22S7vvnm028925;
        Mon, 28 Mar 2022 08:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Zs6dBemfH8IrRviMQDnRmbcJfN9uyMeIJp6pMbJ7Ayw=;
 b=ar0ny7IMuWQWwfhJGU69UpC2xMZiaaUdqkfY1+As/ijrzyCpZQ/Y+iMYbvSmnx/Htz2c
 E564nRuALc8Oa7GpqCRzTTn/tE3CwLEvSwnJDaAItY8yciR3ll0Qgthxwjq6ExrqBr8x
 EpeYZqezfq2RKxXunEFQ9Z3YzXWQQX5L2EhhGgTVKHvVyce9t8clcrrwGhP1qSTk5I+t
 osWKSxrqobLrfX8ye6eInc0JGEp9TP+ikGl/3JDvJbTlORBDHfB9oyQwA5gCuMtwgHU+
 3v537a0g2x9h7HZ4MvahuoEHFXv4Rv5d6EyF8GKm7H25LF/LsoiO8v+1ve4aTJACzLZZ Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f393gg2y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:01:49 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22S80eNL008174;
        Mon, 28 Mar 2022 08:01:48 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f393gg2xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:01:48 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22S7rVXj026618;
        Mon, 28 Mar 2022 08:01:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3f1tf8twnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:01:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22S81hVr44499230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 08:01:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D04B52050;
        Mon, 28 Mar 2022 08:01:43 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.198])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 18E275204F;
        Mon, 28 Mar 2022 08:01:43 +0000 (GMT)
Message-ID: <477b6fc8a6fa036dfaed951e69c6de279bc5c05b.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: gs: move to new header file
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Date:   Mon, 28 Mar 2022 10:01:42 +0200
In-Reply-To: <20220325173825.2df90f51@p-imbrenda>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
         <20220323170325.220848-4-nrb@linux.ibm.com> <YjytK7iW7ucw/Gwj@osiris>
         <a2870c6b-6b2a-0a81-435e-ec0f472697c6@linux.ibm.com>
         <20220325153048.48306e40@p-imbrenda>
         <34d7549b-40c0-a010-3a05-2adbe5f9c41d@linux.ibm.com>
         <20220325173825.2df90f51@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ws-sd20zB1btYzunF9SQ25gpaSXYzHyZ
X-Proofpoint-ORIG-GUID: Pm1cePHkuhISnPnKAP8oHc_mLpb8B8k_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_02,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-25 at 17:38 +0100, Claudio Imbrenda wrote:
> > Do we need load_guarded() in this new header?
> > The load/store_gscb() functions have potential to be shared across
> > tests 
> > but the lg doesn't need to be executed, no?
> > 
> > We could opt to leave it in gs.c instead
> 
> yes, probably a better idea. I'd still add the comment, though :)
> 
> shall I just fix this up when picking?

I like the suggestion by Janosch.

Since I will sent the ADTL STATUS test (patch 4) in a seperate series
anyways, I think it makes more sense if I include the patch there and
you don't pick patches 3 and 4 from this series.
